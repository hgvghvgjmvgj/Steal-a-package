# Moving the project with Git

Git versions the Luau backups, documentation, test evidence and curated reference gallery. It does not synchronize Roblox Studio or transfer the Codex conversation, Roblox player data, credentials or MCP installation.

A local Git repository and initial commit have been prepared. The project is connected to https://github.com/hgvghvgjmvgj/Steal-a-package and the initial commit has been pushed to `main`. Check repository visibility in GitHub Settings if it should be private. The commands below document the initial connection; do not add `origin` again on this PC:

```powershell
git remote add origin https://github.com/hgvghvgjmvgj/Steal-a-package.git
git push -u origin main
```

On the laptop:

```powershell
git clone https://github.com/hgvghvgjmvgj/Steal-a-package.git
cd Steal-a-package
```

Open the cloned folder in Codex and read docs/HANDOFF.md. Save/transfer the full Roblox place separately as described there. `.rbxl` and `.rbxlx` backups are excluded from this repository; source ZIPs are retained as historical backups. Selected reference screenshots are included; raw and unselected captures are excluded without being deleted locally.

For later changes, review `git status` and `git diff`, commit intentional changes and push on one machine; pull on the other before starting work. Git commits should accompany Studio saves because the code backup and place can otherwise diverge.
