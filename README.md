# Project Git Workflow Guide

This document outlines our Git workflow, including branching strategy and commit message conventions, to ensure consistency and collaboration across the team.

---

## 📚 Table of Contents

- [Branching Strategy](#-branching-strategy)
- [Creating a New Branch](#-creating-a-new-branch)
- [Commit Message Guidelines](#-commit-message-guidelines)
  - [Add](#-add)
  - [Fix](#-fix)
  - [Update](#-update)
  - [Delete](#-delete)
- [Commit Message Tips](#-commit-message-tips)
- [Pull Request Process](#-pull-request-process)

---

## 📁 Branching Strategy

We follow a structured Git branching model to keep development organized and production-ready.

### 🔹 `main`
- **Production branch**
- Contains the final, stable, and deployable version of the code.

### 🔹 `staging`
- **Staging branch**
- Used for integration and testing before merging into `main`.

### 🔹 `features/<feature-name>`
- **Feature branches**
- Used to develop new features in isolation.
- Keeps the codebase modular and reduces the risk of conflicts.

### 🔹 `fix/<feature-name>`
- **Fix branches**
- Used to develop bug fixes or patches for specific features.

---

## 🛠️ Creating a New Branch

To create a new **feature** branch:

```bash
git checkout -b features/<feature-name>
```

To create a new **fix** branch:

```bash
git checkout -b fix/<feature-name>
```

Replace `<feature-name>` with a clear, concise name that reflects the purpose of the branch.

---

## ✍️ Commit Message Guidelines

We use a consistent commit message format to keep history clear and meaningful. Use the following prefixes:

### ✅ `Add:`
Use when adding new features, files, or components.  
**Example:**
```
Add: user authentication middleware
```

### 🐛 `Fix:`
Use when fixing bugs or correcting code behavior.  
**Example:**
```
Fix: incorrect login validation on the frontend
```

### ♻️ `Update:`
Use when improving existing code (e.g. refactoring or performance tweaks) without changing its core functionality.  
**Example:**
```
Update: optimized API response handling
```

### 🗑️ `Delete:`
Use when removing code, files, or outdated components.  
**Example:**
```
Delete: removed deprecated user model
```

---

## 🔑 Commit Message Tips

- Use the **imperative mood** (e.g., "Add", not "Added").
- Keep messages **short but descriptive**.
- Focus on **what** changed, not **how** or **why**—that belongs in the pull request or code review.
- Be consistent to make collaboration easier for everyone.

---

## 📑 Pull Request Process

Once your feature branch (`features/<feature-name>`) is fully developed and ready for integration:

1. **Push your branch** to the remote repository:
    ```bash
    git push origin features/<feature-name>
    ```

2. **Create a Pull Request (PR)**:
    - Navigate to your repository on GitHub.
    - Go to the "Pull Requests" tab and click "New Pull Request".
    - Select your feature branch (`features/<feature-name>`) and compare it against the `staging` branch.
    - Add a clear description of the changes made, why they were made, and any relevant context.

3. **Request a Review**:
    - Assign the PR to another developer for review.
    - The reviewer will check for any issues, bugs, or improvements.
    - Address any feedback or required changes before approval.

4. **Merge the PR**:
    - Once the PR has been reviewed and approved, merge it into the `staging` branch.

5. **Clean up**:
    - After the PR is merged, delete the feature branch both locally and remotely to keep the repository clean:
    ```bash
    git branch -d features/<feature-name>
    git push origin --delete features/<feature-name>
    ```


