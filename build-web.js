#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const LOVE_FILE = 'healingwave.love';
const DIST_DIR = 'dist';
const GAME_TITLE = 'Healing Wave';
const MEMORY_SIZE = 67108864; // 64MB

// Files and directories to exclude from the .love archive
const EXCLUDE_PATTERNS = [
  '"*.git*"',
  '"*node_modules*"',
  '"*dist*"',
  '"*.DS_Store"',
  '"*.love"',
  '"build-web.sh"',
  '"build-web.js"',
  '"package.json"',
  '"package-lock.json"',
  '"TODO.md"',
  '"*.md"'
];

console.log('Building Healing Wave for web...\n');

// Step 1: Clean previous builds
console.log('Cleaning previous builds...');
if (fs.existsSync(DIST_DIR)) {
  fs.rmSync(DIST_DIR, { recursive: true, force: true });
}
if (fs.existsSync(LOVE_FILE)) {
  fs.unlinkSync(LOVE_FILE);
}

// Step 2: Create .love file (zip archive)
console.log('Creating .love file...');
const excludeArgs = EXCLUDE_PATTERNS.map(pattern => `-x ${pattern}`).join(' ');
const zipCommand = `zip -9 -r ${LOVE_FILE} . ${excludeArgs}`;

try {
  execSync(zipCommand, { stdio: 'inherit' });
} catch (error) {
  console.error('Error creating .love file:', error.message);
  process.exit(1);
}

// Step 3: Build web version using love.js
console.log('\nBuilding web version with love.js...');
const lovejsCommand = `npx love.js ${LOVE_FILE} ${DIST_DIR} -t "${GAME_TITLE}" -m ${MEMORY_SIZE} -c`;

try {
  execSync(lovejsCommand, { stdio: 'inherit' });
} catch (error) {
  console.error('Error building with love.js:', error.message);
  process.exit(1);
}

// Step 4: Apply post-build customizations
console.log('\nApplying post-build customizations...');
try {
  execSync('node post-build.js', { stdio: 'inherit' });
} catch (error) {
  console.error('Error in post-build script:', error.message);
  process.exit(1);
}

console.log('\n✓ Build complete! Output in dist/');
console.log('To test locally, run: npm run serve');
