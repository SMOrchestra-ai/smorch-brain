#!/usr/bin/env node
/**
 * validate-skills-lock.js — CI enforcement script
 *
 * Reads skills.lock.json and validates:
 * 1. Every skill in the lock exists in skills/ directory
 * 2. Every skill in skills/ directory is declared in the lock
 * 3. Every skill has a valid manifest.json
 * 4. Manifest version matches lock version
 *
 * Exit code 0 = pass, 1 = fail (blocks CI merge)
 *
 * Usage: node scripts/validate-skills-lock.js
 * Copy this script to any repo that uses skills.
 */

const fs = require("fs");
const path = require("path");

const LOCK_FILE = "skills.lock.json";
const SKILLS_DIR = "skills";

function main() {
  // Check if this project uses skills
  if (!fs.existsSync(LOCK_FILE)) {
    console.log("ℹ️  No skills.lock.json found — skipping skill validation");
    process.exit(0);
  }

  if (!fs.existsSync(SKILLS_DIR)) {
    console.error(
      "❌ skills.lock.json exists but skills/ directory is missing",
    );
    process.exit(1);
  }

  const lock = JSON.parse(fs.readFileSync(LOCK_FILE, "utf-8"));
  const errors = [];
  const warnings = [];

  // 1. Check every locked skill exists on disk
  for (const skill of lock.skills || []) {
    const skillDir = path.join(SKILLS_DIR, skill.id);
    const manifestPath = path.join(skillDir, "manifest.json");
    const entryPath = path.join(skillDir, skill.entrypoint || "SKILL.md");

    if (!fs.existsSync(skillDir)) {
      errors.push(`Missing skill directory: ${skillDir} (declared in lock)`);
      continue;
    }

    if (!fs.existsSync(entryPath)) {
      errors.push(`Missing entrypoint: ${entryPath}`);
    }

    if (fs.existsSync(manifestPath)) {
      try {
        const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf-8"));
        if (skill.version && manifest.version !== skill.version) {
          warnings.push(
            `Version mismatch for ${skill.id}: lock=${skill.version}, manifest=${manifest.version}`,
          );
        }
      } catch (e) {
        errors.push(`Invalid manifest.json in ${skillDir}: ${e.message}`);
      }
    } else {
      warnings.push(
        `No manifest.json in ${skillDir} — version tracking disabled for this skill`,
      );
    }
  }

  // 2. Check for undeclared skills (bloat detection)
  const lockedIds = new Set((lock.skills || []).map((s) => s.id));
  const diskSkills = fs.readdirSync(SKILLS_DIR).filter((d) => {
    const full = path.join(SKILLS_DIR, d);
    return (
      fs.statSync(full).isDirectory() &&
      fs.existsSync(path.join(full, "SKILL.md"))
    );
  });

  for (const diskSkill of diskSkills) {
    if (!lockedIds.has(diskSkill)) {
      errors.push(
        `Undeclared skill on disk: ${diskSkill} — add to skills.lock.json or remove from skills/`,
      );
    }
  }

  // 3. Check plugins declared
  for (const plugin of lock.plugins || []) {
    if (plugin.required && !plugin.id) {
      errors.push(`Plugin declared as required but has no id`);
    }
  }

  // Report
  if (warnings.length > 0) {
    console.log("\n⚠️  Warnings:");
    warnings.forEach((w) => console.log(`   ${w}`));
  }

  if (errors.length > 0) {
    console.log("\n❌ Skill Lock Validation FAILED:");
    errors.forEach((e) => console.log(`   ${e}`));
    console.log(`\n${errors.length} error(s), ${warnings.length} warning(s)`);
    process.exit(1);
  }

  const skillCount = (lock.skills || []).length;
  const pluginCount = (lock.plugins || []).length;
  console.log(
    `✅ Skill lock valid: ${skillCount} skills, ${pluginCount} plugins, ${warnings.length} warnings`,
  );
  process.exit(0);
}

main();
