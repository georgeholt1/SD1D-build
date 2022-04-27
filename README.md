# SD1D Build

Scripts for building [SD1D](https://github.com/boutproject/SD1D).

Directory names in the repository root correspond to the machine on which the contained scripts should be run. For example, the scripts in the `marconi` directory are for the Tier-0 [MARCONI](https://www.hpc.cineca.it/hardware/marconi) system at Cineca.

## Usage

1. Clone this repository.
2. `cd` into the machine directory.
3. Activate the environment
   ```
   source SD1D.env
   ```
4. Build the dependencies
   ```
   ./build-dependencies.sh
   ```
5. Build SD1D
   ```
   ./build-SD1D.sh
   ```

Note: You may need to change permissions to make the bash scripts executable
```
chmod +x <script>.sh
```
