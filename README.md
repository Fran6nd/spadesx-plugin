# SpadesX Plugin Template

[![Build Plugin](https://github.com/YOUR_USERNAME/spadesx-plugin-template/workflows/Build%20Plugin/badge.svg)](https://github.com/YOUR_USERNAME/spadesx-plugin-template/actions)

A standalone template repository for developing [SpadesX](https://github.com/SpadesX/SpadesX) server plugins. This template provides a complete cross-platform build system with GitHub Actions CI/CD support.

## Features

- 🚀 **Quick Start**: Clone and start coding immediately
- 🔧 **Cross-Platform**: Builds on Linux, macOS, and Windows
- ⚙️ **CMake + Makefile**: Flexible build system
- 🤖 **GitHub Actions**: Automatic builds and releases for all platforms
- 📦 **Self-Contained**: Includes PluginAPI.h, no SpadesX source needed
- 🎯 **Production Ready**: Optimized release builds

## Quick Start

### Prerequisites

- **Linux**: `build-essential`, `cmake`
- **macOS**: Xcode Command Line Tools, `cmake` (via Homebrew)
- **Windows**: Visual Studio 2019+ or MinGW, CMake

### Clone and Build

```bash
# Clone this template
git clone https://github.com/YOUR_USERNAME/your-plugin-name.git
cd your-plugin-name

# Build the plugin
make

# Output will be in build/plugins/my_plugin.{so|dylib|dll}
```

## Usage

### Building Your Plugin

**Option 1: Using the template as-is**
```bash
# Edit template_plugin.c with your code
make
```

**Option 2: Create your own plugin file**
```bash
# Create your plugin source file
cp template_plugin.c my_gamemode.c
# Edit my_gamemode.c

# Build with custom name
make PLUGIN_NAME=my_gamemode PLUGIN_SOURCE=my_gamemode.c
```

### Build Commands

```bash
make                 # Build plugin (release mode)
make debug           # Build with debug symbols
make clean           # Remove build artifacts
make distclean       # Deep clean (including downloaded headers)
make help            # Show all available commands
```

### CMake Direct Usage

```bash
mkdir build && cd build
cmake .. -DPLUGIN_NAME=my_plugin -DPLUGIN_SOURCE=template_plugin.c
cmake --build . --config Release
```

## Plugin Development

### Project Structure

```
your-plugin/
├── template_plugin.c     # Example plugin (or your custom .c file)
├── PluginAPI.h           # SpadesX plugin API header
├── CMakeLists.txt        # CMake build configuration
├── Makefile              # Convenient build wrapper
├── README.md             # This file
├── .github/
│   └── workflows/
│       └── build.yml     # CI/CD configuration
└── .gitignore
```

### Creating Your Plugin

1. **Copy the template** or create a new `.c` file:
   ```c
   #include "PluginAPI.h"

   PLUGIN_EXPORT plugin_info_t spadesx_plugin_info = {
       .name = "My Plugin",
       .version = "1.0.0",
       .author = "Your Name",
       .description = "What it does",
       .api_version = SPADESX_PLUGIN_API_VERSION
   };

   PLUGIN_EXPORT int spadesx_plugin_init(server_t* server, const plugin_api_t* api) {
       api->log_info(spadesx_plugin_info.name, "Plugin loaded!");
       return 0;
   }

   PLUGIN_EXPORT void spadesx_plugin_shutdown(server_t* server) {
       // Cleanup
   }
   ```

2. **Add event handlers** (optional):
   ```c
   PLUGIN_EXPORT void spadesx_plugin_on_player_connect(server_t* server, player_t* player) {
       // Handle player connection
   }
   ```

3. **Build and test**:
   ```bash
   make PLUGIN_NAME=my_plugin PLUGIN_SOURCE=my_plugin.c
   ```

### Available Event Handlers

See `template_plugin.c` for a complete example with all event handlers:

- `on_server_init` - Server startup (map initialization)
- `on_server_shutdown` - Server shutdown
- `on_tick` - Every server tick (~60Hz)
- `on_block_place` - Block placement (can deny)
- `on_block_destroy` - Block destruction (can deny)
- `on_player_connect` - Player joins
- `on_player_disconnect` - Player leaves
- `on_player_hit` - Player damage (can deny)
- `on_command` - Custom commands
- `on_grenade_explode` - Grenade detonation
- `on_color_change` - Player color change (can deny)

### Plugin API

The `plugin_api_t` structure provides access to:

**Player Functions**:
- `get_player(server, id)` - Get player by ID
- `player_get_name(player)` - Get player name
- `player_get_team(server, player)` - Get player team
- `player_set_hp(player, hp)` - Set player health
- `player_send_notice(player, message)` - Send message to player
- `player_restock(player)` - Restock player ammo

**Map Functions**:
- `map_get_block(map, x, y, z)` - Get block color
- `map_set_block(server, x, y, z, color)` - Place block
- `map_remove_block(server, x, y, z)` - Remove block

**Server Functions**:
- `broadcast_message(server, message)` - Message all players
- `register_command(server, name, desc, handler, perms)` - Add custom command

**Logging**:
- `log_info(plugin_name, format, ...)` - Log info message
- `log_warning(plugin_name, format, ...)` - Log warning
- `log_error(plugin_name, format, ...)` - Log error
- `log_debug(plugin_name, format, ...)` - Log debug message

## GitHub Actions CI/CD

This template includes automatic builds for all platforms.

### Automatic Builds

Every push triggers builds for:
- 🐧 Linux (`.so`)
- 🍎 macOS (`.dylib`)
- 🪟 Windows (`.dll`)

Build artifacts are available in the Actions tab.

### Creating Releases

To create a release with pre-built binaries:

```bash
# Tag your version
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions will automatically:
1. Build for all platforms
2. Create a GitHub Release
3. Attach all plugin binaries

### Customizing Workflows

Edit `.github/workflows/build.yml` to:
- Change plugin name
- Add additional build steps
- Modify build configurations
- Add testing

## Deployment

### Installing on SpadesX Server

1. Build your plugin or download from releases
2. Copy the plugin to SpadesX `plugins/` directory:
   ```bash
   # Linux
   cp build/plugins/my_plugin.so /path/to/spadesx/plugins/

   # macOS
   cp build/plugins/my_plugin.dylib /path/to/spadesx/plugins/

   # Windows
   copy build\plugins\my_plugin.dll C:\path\to\spadesx\plugins\
   ```
3. Start the server - plugin loads automatically

### Distribution

Share your plugin by:
- Publishing releases on GitHub (automatic binaries)
- Sharing the source code for others to build
- Creating packages for plugin managers

## Troubleshooting

### Build Fails

**Missing PluginAPI.h**:
```bash
# CMake will try to download it automatically
# Or manually copy from SpadesX repository
wget https://raw.githubusercontent.com/SpadesX/SpadesX/master/Source/Server/PluginAPI.h
```

**Compiler not found**:
- Linux: `sudo apt-get install build-essential cmake`
- macOS: `xcode-select --install && brew install cmake`
- Windows: Install Visual Studio or MinGW

**CMake version too old**:
```bash
# Minimum version 3.10 required
cmake --version
# Update via package manager or download from cmake.org
```

### Plugin Won't Load

- Check API version matches: `SPADESX_PLUGIN_API_VERSION`
- Verify all required exports: `spadesx_plugin_info`, `spadesx_plugin_init`, `spadesx_plugin_shutdown`
- Check server logs for error messages
- Ensure correct platform (`.so` for Linux, `.dylib` for macOS, `.dll` for Windows)

## Examples

### Minimal Plugin

See `template_plugin.c` for a full-featured example.

For a minimal plugin:
```c
#include "PluginAPI.h"

PLUGIN_EXPORT plugin_info_t spadesx_plugin_info = {
    .name = "Minimal Plugin",
    .version = "1.0.0",
    .author = "Me",
    .description = "Does nothing",
    .api_version = SPADESX_PLUGIN_API_VERSION
};

PLUGIN_EXPORT int spadesx_plugin_init(server_t* s, const plugin_api_t* api) {
    (void)s;
    api->log_info(spadesx_plugin_info.name, "Hello World!");
    return 0;
}

PLUGIN_EXPORT void spadesx_plugin_shutdown(server_t* s) {
    (void)s;
}
```

Build:
```bash
make PLUGIN_NAME=minimal PLUGIN_SOURCE=minimal.c
```

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on all platforms (use GitHub Actions)
5. Submit a pull request

## License

This template and example code is licensed under **GNU General Public License v3.0** (GPL-3.0), the same license as SpadesX.

**What this means for your plugin:**
- This template and build system: GPL-3.0
- PluginAPI.h: Part of SpadesX, GPL-3.0
- **Your plugin code**: Must also be GPL-3.0 (or compatible) if you distribute it

Plugins are derivative works of SpadesX and must comply with GPL-3.0 requirements:
- Source code must be available
- Any modifications must also be GPL-3.0
- No additional restrictions can be imposed

See [LICENSE](LICENSE) for full GPL-3.0 terms.

## Resources

- [SpadesX Repository](https://github.com/SpadesX/SpadesX)
- [SpadesX Documentation](https://github.com/SpadesX/SpadesX/wiki)
- [Plugin API Reference](PluginAPI.h)
- [Example Plugins](https://github.com/SpadesX/SpadesX/tree/master/plugins)

## Support

- 🐛 [Report Issues](https://github.com/YOUR_USERNAME/your-plugin-name/issues)
- 💬 [Discussions](https://github.com/YOUR_USERNAME/your-plugin-name/discussions)
- 📖 [Wiki](https://github.com/YOUR_USERNAME/your-plugin-name/wiki)

---

**Happy Plugin Development! 🎮**
