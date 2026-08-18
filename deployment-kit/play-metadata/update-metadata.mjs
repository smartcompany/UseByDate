#!/usr/bin/env node
/**
 * Upload Google Play store listing (title, short/full description) via Android Publisher API.
 */

import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  createAndroidPublisher,
  loadListings,
  requirePlayEnv,
  withEdit,
} from './lib/play.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const FIELDS = ['title', 'shortDescription', 'fullDescription'];

function parseArgs(argv) {
  const args = {
    dryRun: false,
    listingsFile: path.join(__dirname, 'listings.mjs'),
    only: new Set(FIELDS),
    help: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--dry-run') args.dryRun = true;
    else if (a === '--listings') args.listingsFile = path.resolve(argv[++i]);
    else if (a === '--only') {
      args.only = new Set(
        argv[++i]
          .split(',')
          .map((s) => s.trim())
          .filter(Boolean),
      );
    } else if (a === '--help' || a === '-h') args.help = true;
  }
  return args;
}

function pickListing(entry, only) {
  const out = {};
  for (const key of only) {
    const v = entry[key];
    if (v != null && String(v).trim() !== '') {
      out[key] = String(v).trim();
    }
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(`Usage: node update-metadata.mjs [options]

Options:
  --dry-run              Preview only
  --listings FILE        Default: ./listings.mjs
  --only title,shortDescription,fullDescription
`);
    process.exit(0);
  }

  for (const f of args.only) {
    if (!FIELDS.includes(f)) throw new Error(`Unknown field: ${f}`);
  }

  const listings = await loadListings(args.listingsFile);
  const locales = Object.keys(listings).sort();

  if (args.dryRun) {
    console.log(`Package: ${process.env.PLAY_PACKAGE_NAME || 'com.smartcompany.useByDate'}`);
    console.log(`Locales: ${locales.join(', ')}`);
    console.log(`Fields: ${[...args.only].join(', ')}\n`);
    for (const locale of locales) {
      const body = pickListing(listings[locale], args.only);
      console.log(`=== ${locale} ===`);
      for (const [k, v] of Object.entries(body)) {
        const preview = v.length > 100 ? `${v.slice(0, 100)}…` : v;
        console.log(`  ${k}: ${preview}`);
      }
    }
    return;
  }

  const { jsonPath, packageName } = requirePlayEnv(__dirname);

  console.log(`Package: ${packageName}`);
  console.log(`Service account: ${jsonPath}`);
  console.log(`Locales: ${locales.join(', ')}`);
  console.log(`Fields: ${[...args.only].join(', ')}\n`);

  const androidpublisher = await createAndroidPublisher(jsonPath);

  await withEdit(androidpublisher, packageName, async (editId) => {
    for (const locale of locales) {
      const requestBody = pickListing(listings[locale], args.only);
      if (Object.keys(requestBody).length === 0) continue;
      console.log(`Updating ${locale}…`);
      await androidpublisher.edits.listings.update({
        editId,
        packageName,
        language: locale,
        requestBody,
      });
      console.log(`✓ ${locale}`);
    }
  });

  console.log('\nDone — listing changes committed.');
}

main().catch((err) => {
  console.error(err.message || err);
  if (err.code === 'PLAY_PACKAGE_NOT_FOUND') {
    console.error(
      '\nCreate the app in Google Play Console first, upload the first AAB, then rerun metadata upload.',
    );
    process.exit(2);
  }
  process.exit(1);
});
