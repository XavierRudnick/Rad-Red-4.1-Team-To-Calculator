# Rad Red 4.1 Team to Damage Calculator

This tool automates importing your Pokemon team from Rad Red 4.1 (a Pokemon Ruby hack) into the Pokemon Showdown Damage Calculator.

## Prerequisites

- **mGBA Emulator**: For running the ROM hack.
- **Python 3**: With `selenium` and `pandas` installed.
- **Google Chrome**: For the damage calculator.
- **Pokemon Showdown Damage Calculator**: Local build.

## Setup

### 1. Damage Calculator Setup

1. Clone or download the damage calculator repository.
2. Navigate to the `damage-calc` directory.
3. Run `npm install` to install dependencies.
4. Run `npm run build` to build the calculator.
5. Serve the `dist` folder locally (e.g., using VS Code Live Server on port 5500).

### 2. Python Script Setup

1. Install required Python packages:
   ```
   pip install selenium pandas
   ```
2. Download ChromeDriver matching your Chrome version from [here](https://chromedriver.chromium.org/downloads).
3. Place `chromedriver.exe` in a known path (update `driver_path` in `radred_team_extractor.py` if needed).

### 3. Lua Script Setup

1. The `radred_team_extractor.lua` script is ready to use in mGBA.
2. Ensure the paths in the script match your setup (e.g., output path to `party_raw.txt`).

## Usage

### Step 1: Start Chrome with Remote Debugging

To allow the script to control your browser:

```
"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir="C:\temp\chrome-debug-profile"
```

- This opens Chrome in a separate profile to avoid closing your main tabs.
- Navigate to `http://127.0.0.1:5500/damage-calc/dist/normal.html?mode=normal` in this Chrome instance.

### Step 2: Run the Python Watcher

Execute `radred_team_extractor.py` in your terminal. It will monitor `party_raw.txt` for changes.

### Step 3: Export Team from mGBA

1. Load Rad Red 4.1 ROM in mGBA.
2. Load the `radred_team_extractor.lua` script.
3. In-game, press **L + R** to export your current party to `party_raw.txt`.
4. The Python script detects the change, formats the data (including EVs), and automatically imports it into the open damage calculator tab.

### Step 4: View Imported Team

- The team appears in the damage calculator under "Imported Sets".
- EVs are included based on your Pokemon's trained stats.

## Files Overview

- `radred_team_extractor.py`: Main Python script for processing and importing.
- `radred_team_extractor.lua`: mGBA script for exporting raw team data.
- `party_raw.txt`: Temporary file with raw data from mGBA.
- `import_me.txt`: Formatted Showdown export (for debugging).
- `species_abilities.csv`: CSV with Pokemon abilities.
- `Species.txt`, `Moves.txt`, `Items.txt`: Data files for lookups.

## Troubleshooting

- **Lua Errors**: Ensure `PARTY_START` (0x02024284) is correct for Rad Red 4.1. If not, find the correct party address in mGBA's memory viewer.
- **Import Fails**: Check that Chrome is running with `--remote-debugging-port=9222` and the calculator page is open.
- **EVs Not Importing**: Regenerate `party_raw.txt` after Lua updates.
- **Python Errors**: Ensure all paths are correct and dependencies are installed.

## Notes

- The script assumes Rad Red 4.1 uses the same struct offsets as Pokemon Ruby. If offsets differ, update the Lua script accordingly.
- EVs for Sp. Atk and Sp. Def are set to 0, as Gen 3 doesn't store them separately.
- For manual import, paste the contents of `import_me.txt` into the calculator's import box.
