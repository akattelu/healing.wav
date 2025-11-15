#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const CSS_FILE = path.join(__dirname, 'dist', 'theme', 'love.css');

console.log('Applying fullscreen CSS modifications...');

// Read the existing CSS
let css = fs.readFileSync(CSS_FILE, 'utf8');

// Add fullscreen styles for the canvas
const fullscreenCSS = `

/* Fullscreen canvas modifications */
html, body {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  overflow: hidden;
}

center {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

center > div {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
}

#canvas {
  position: absolute !important;
  top: 50% !important;
  left: 50% !important;
  transform: translate(-50%, -50%) !important;
  width: 100vw !important;
  height: 100vh !important;
  object-fit: contain !important;
  max-width: 100% !important;
  max-height: 100% !important;
}

#loadingCanvas {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

h1 {
  position: absolute;
  top: 20px;
  z-index: 10;
}

footer {
  z-index: 10;
}
`;

// Append the fullscreen CSS
css += fullscreenCSS;

// Write it back
fs.writeFileSync(CSS_FILE, css, 'utf8');

console.log('✓ Fullscreen CSS applied successfully!');
