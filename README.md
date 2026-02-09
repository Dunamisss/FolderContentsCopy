# Copy Folder Contents to Text

A simple Windows integration that allows you to right-click any folder and instantly generate a text file on your Desktop containing a clean list of all files within that folder.

## 🚀 How It Works

This project consists of two main components:
1.  **`CopyContents.ps1`**: A PowerShell script that handles the scanning, sorting, and saving of file names.
2.  **`AddCopyContents.reg`**: A Registry file that adds the "Copy Contents" option to your Windows right-click menu.

## 📋 Prerequisites

* **Windows 10 or 11**
* **PowerShell 5.1** or higher

## 🛠️ Installation & Setup

### 1. Save the Script
Place the `CopyContents.ps1` file in a permanent folder on your computer. 

### 2. Update the Registry Path
Before running the Registry file, you **must** tell it where your script is located:
1.  Right-click `AddCopyContents.reg` and select **Edit**.
2.  Locate the line starting with `@="powershell.exe...`.
3.  Replace `C:\\YOUR\\PATH\\TO\\CopyContents.ps1` with the actual path to where you saved the script.
    * *Note: Use double backslashes (`\\`) for the path (e.g., `C:\\Scripts\\CopyContents.ps1`).*

### 3. Apply the Registry Change
1.  Double-click `AddCopyContents.reg`.
2.  Click **Yes** on the Windows confirmation prompt.
3.  Click **OK**.

## 📖 Usage

1.  Open File Explorer.
2.  **Right-click** on any folder.
3.  Select **Copy Contents**.
4.  A file named `Contents - [FolderName].txt` will appear on your **Desktop**.

## ⚙️ Features
* **UTF-8 Encoding:** Supports special characters.
* **Automatic Sorting:** Lists files alphabetically.
* **Top-Level Only:** Only lists files in the selected folder (not subfolders).
