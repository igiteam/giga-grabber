# Giga Grabber - Docker Version

## 🐳 Docker Image Available

The Docker image is automatically built and available at:

```bash
ghcr.io/igiteam/giga-grabber/giga-grabber:latest
```

## 📥 Pull the Image

```bash
docker pull ghcr.io/igiteam/giga-grabber/giga-grabber:latest
```

## 🚀 Usage

### Method 1: Using the helper script

```bash
./docker-run.sh [arguments]
```

### Method 2: Direct Docker command

```bash
docker run --rm -v $(pwd):/data -w /data ghcr.io/igiteam/giga-grabber/giga-grabber:latest [arguments]
```

### Method 3: Create an alias for easier use

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
alias gigagrab='docker run --rm -v "$(pwd):/data" -w /data ghcr.io/igiteam/giga-grabber/giga-grabber:latest'
```

Then use it like:

```bash
gigagrab --help
```

## 🔄 Get the Latest Version

```bash
docker pull ghcr.io/igiteam/giga-grabber/giga-grabber:latest
```

## 🏷️ Version Tags

- `latest` - Latest build from main branch
- `vX.Y.Z` - Specific version releases
- `sha-XXXXXXX` - Specific commit SHA

## 💡 Examples

```bash
# Show help
./docker-run.sh --help

# Run with specific arguments (adjust based on actual giga-grabber usage)
./docker-run.sh --input /data/input.txt --output /data/output.txt
```

## 🔧 Local Development

To build locally:

```bash
docker build -t giga-grabber-local .
docker run --rm giga-grabber-local --help
```
