# Moving the project with Git

Git versions the Luau backups, documentation, test evidence and curated reference gallery. It does not synchronize Roblox Studio or transfer the Codex conversation, Roblox player data, credentials or MCP installation.

A local Git repository and initial commit have been prepared. No remote repository is configured or uploaded by this setup. Create an empty **private** GitHub repository (do not add a README/license/gitignore there), then run from this project folder:

```powershell
git remote add origin https://github.com/YOUR-ACCOUNT/steal-a-package.git
git push -u origin main
```

On the laptop:

```powershell
git clone https://github.com/YOUR-ACCOUNT/steal-a-package.git
cd steal-a-package
```

Open the cloned folder in Codex and read docs/HANDOFF.md. Save/transfer the full Roblox place separately as described there. `.rbxl` and `.rbxlx` backups are excluded from this repository; source ZIPs are retained as historical backups. Selected reference screenshots are included; raw and unselected captures are excluded without being deleted locally.

For later changes, review `git status` and `git diff`, commit intentional changes and push on one machine; pull on the other before starting work. Git commits should accompany Studio saves because the code backup and place can otherwise diverge.
