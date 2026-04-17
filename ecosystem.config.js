module.exports = {
  apps: [
    {
      name: "smorch-brain",
      script: "npm",
      args: "start",
      cwd: "/opt/apps/smorch-brain",
      env: { NODE_ENV: "production", PORT: 3400 },
      instances: 1,
      autorestart: true,
      max_memory_restart: "256M",
    },
  ],
  deploy: {
    production: {
      host: "smo-brain",
      ref: "origin/dev",
      repo: "git@github.com:SMOrchestra-ai/smorch-brain.git",
      path: "/opt/apps/smorch-brain",
      "post-deploy": "npm ci --production && pm2 reload ecosystem.config.js",
    },
  },
};
