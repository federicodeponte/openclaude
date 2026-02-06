# Browser-Use: Self-Hosted Browser Automation for Product Audits

A comprehensive guide to running [browser-use](https://github.com/browser-use/browser-use) locally with Ollama for automated product testing, UI audits, and screenshot verification — **no cloud APIs required**.

## Why Self-Hosted?

- **Privacy**: All data stays on your machine
- **Cost**: No API fees after initial setup
- **Speed**: No network latency for LLM calls
- **Control**: Full control over model selection and behavior

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 16GB | 32GB |
| Storage | 12GB (for models) | 20GB+ |
| CPU | 4 cores | 8+ cores |
| GPU | Optional | NVIDIA with 8GB+ VRAM |
| Python | 3.11+ | 3.11+ |
| OS | macOS, Linux, Windows (WSL2) | macOS, Linux |

## Quick Start

### 1. Install Ollama

```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.com/install.sh | sh

# Start the server
ollama serve
```

### 2. Pull a Model

```bash
# Recommended: Good balance of speed and capability
ollama pull qwen2.5:7b

# Alternative: Better reasoning (requires more RAM)
ollama pull qwen2.5:14b

# For vision/screenshot analysis
ollama pull qwen2.5vl:7b
```

### 3. Install Browser-Use

```bash
# Create project directory
mkdir browser-audit && cd browser-audit

# Create virtual environment
python -m venv venv
source venv/bin/activate  # macOS/Linux
# or: venv\Scripts\activate  # Windows

# Install dependencies
pip install browser-use langchain langchain-ollama

# Install browser
playwright install chromium
```

### 4. Run Your First Audit

Create `audit.py`:

```python
import asyncio
from browser_use import Agent
from langchain_ollama import ChatOllama

async def run_audit():
    agent = Agent(
        task="Navigate to https://example.com, take a screenshot, and describe what you see",
        llm=ChatOllama(
            model="qwen2.5:7b",
            num_ctx=32000,
        ),
        max_actions_per_step=3,
        tool_call_in_content=False,
        generate_gif=True,                    # Record actions as GIF
        save_conversation_path="audit.json",  # Save full history
    )
    result = await agent.run(max_steps=15)
    return result

if __name__ == "__main__":
    result = asyncio.run(run_audit())
    print(result)
```

Run it:

```bash
python audit.py
```

## Model Recommendations

| Model | Size | Best For | RAM Needed |
|-------|------|----------|------------|
| `qwen2.5:7b` | 6GB | General automation, forms, navigation | 16GB |
| `qwen2.5:14b` | ~9GB | Complex reasoning, multi-step tasks | 24GB |
| `qwen2.5:32b` | ~21GB | Maximum accuracy | 48GB |
| `deepseek-r1:7b` | ~5GB | Strong reasoning, smaller footprint | 16GB |
| `llama3.1:8b` | ~5GB | Good all-rounder | 16GB |

### Vision Models (for screenshot analysis)

| Model | Size | Capabilities |
|-------|------|--------------|
| `qwen2.5vl:7b` | 6GB | UI understanding, OCR, element detection |
| `qwen2.5vl:3b` | 3.2GB | Lighter option, still capable |
| `llava:7b` | ~5GB | General image understanding |
| `minicpm-v` | ~5.5GB | Compact, good for forms/documents |

## Product Audit Examples

### E-commerce Checkout Flow

```python
async def audit_checkout():
    agent = Agent(
        task="""
        1. Go to https://shop.example.com
        2. Add the first product to cart
        3. Go to checkout
        4. Screenshot each step
        5. Report any errors or broken elements
        """,
        llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
        generate_gif="checkout_flow.gif",
        save_conversation_path="checkout_audit.json",
    )
    return await agent.run(max_steps=25)
```

### Form Validation Testing

```python
async def test_form_validation():
    agent = Agent(
        task="""
        1. Navigate to https://app.example.com/signup
        2. Try submitting the form empty - screenshot any error messages
        3. Enter invalid email format - screenshot the validation error
        4. Enter valid data and submit
        5. Report all validation behaviors observed
        """,
        llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
        generate_gif="form_validation.gif",
    )
    return await agent.run(max_steps=20)
```

### Responsive Design Check

```python
from browser_use import Agent, Browser

async def check_responsive():
    # Test mobile viewport
    browser = Browser(headless=False, window_size=(375, 812))  # iPhone X

    agent = Agent(
        task="""
        Navigate to https://example.com and:
        1. Screenshot the mobile layout
        2. Check if navigation is accessible
        3. Verify text is readable
        4. Report any overflow or layout issues
        """,
        llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
        browser=browser,
        generate_gif="mobile_check.gif",
    )
    return await agent.run(max_steps=15)
```

## Recording & Evidence

### Save Screenshots at Each Step

```python
agent = Agent(
    task="Your task here",
    llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
    generate_gif=True,  # or "path/to/output.gif"
)
```

### Save Full Conversation History

```python
agent = Agent(
    task="Your task here",
    llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
    save_conversation_path="audit_log.json",
    save_conversation_path_encoding="utf-8",
)
```

### Export to Jupyter Notebook

After running, you can export the session:

```python
from browser_use import export_to_ipynb, session_to_python_script

# Export as Jupyter notebook with screenshots
notebook_path = export_to_ipynb(agent, "product_audit.ipynb")

# Export as Python script
python_script = session_to_python_script(agent)
```

## Web UI Alternative

For a visual interface, use browser-use/web-ui:

```bash
# Clone and setup
git clone https://github.com/browser-use/web-ui.git
cd web-ui

# Option 1: Docker (recommended)
docker compose up --build
# Access at http://localhost:7788
# VNC viewer at http://localhost:6080/vnc.html

# Option 2: Manual
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
playwright install --with-deps
python webui.py --ip 127.0.0.1 --port 7788
```

Configure Ollama in the Web UI:
1. Select "Ollama" as the LLM provider
2. Set base URL to `http://localhost:11434`
3. Choose your model (e.g., `qwen2.5:7b`)

## Available Browser Actions

| Action | Description |
|--------|-------------|
| `navigate` | Go to a URL |
| `click` | Click an element by index |
| `input` | Type text into a form field |
| `scroll` | Scroll the page |
| `screenshot` | Capture current state |
| `wait` | Pause for specified duration |
| `go_back` | Navigate back |
| `search` | Search via DuckDuckGo/Google/Bing |
| `extract` | Extract structured data |
| `evaluate` | Execute custom JavaScript |
| `find_text` | Locate and scroll to text |
| `upload_file` | Attach files to inputs |
| `dropdown_options` | List dropdown choices |
| `select_dropdown` | Select a dropdown value |
| `switch` | Change browser tabs |
| `close` | Close a tab |

## Troubleshooting

### Ollama Connection Issues

```bash
# Verify Ollama is running
curl http://localhost:11434/api/tags

# Check if model is downloaded
ollama list

# Restart Ollama
pkill ollama && ollama serve
```

### Browser Not Opening

```bash
# Reinstall Playwright browsers
playwright install chromium --with-deps

# Run with visible browser for debugging
Browser(headless=False)
```

### LLM Timeout Errors

If you see "LLM call timed out after 90 seconds":

1. Use a smaller model (`qwen2.5:7b` instead of `qwen2.5:14b`)
2. Ensure Ollama has enough RAM
3. Check GPU acceleration is working:
   ```bash
   ollama run qwen2.5:7b "test"  # Should respond quickly
   ```

### Vision Model Not Working

Known issue: browser-use may have `supports_vision=False` hardcoded for Ollama. Workaround:

```python
# Take screenshots with browser-use
agent = Agent(task="Navigate and screenshot", ...)

# Analyze screenshots separately with vision model
import ollama

response = ollama.chat(
    model="qwen2.5vl:7b",
    messages=[{
        "role": "user",
        "content": "Describe this UI screenshot",
        "images": ["screenshot.png"]
    }]
)
```

## Integration with Claude Code

### Using as MCP Server (Cloud)

If you need Claude Code integration, browser-use offers an MCP server:

```bash
claude mcp add --transport http browser-use https://api.browser-use.com/mcp
```

Note: This requires a Browser Use Cloud API key (not self-hosted).

### Local Alternative: Run Scripts via Bash

Create audit scripts and run them from Claude Code:

```bash
# In Claude Code
python /path/to/audit.py --url "https://example.com" --task "check homepage"
```

## Resources

- [browser-use GitHub](https://github.com/browser-use/browser-use)
- [browser-use/web-ui](https://github.com/browser-use/web-ui)
- [browser-use Documentation](https://docs.browser-use.com)
- [Ollama](https://ollama.com)
- [Ollama Vision Models](https://ollama.com/search?c=vision)
- [Qwen2.5-VL](https://ollama.com/library/qwen2.5vl)

## Known Limitations

1. **Vision model integration**: Ollama vision models may not work directly with browser-use's screenshot tool due to hardcoded flags
2. **Complex multi-tab workflows**: May require explicit tab management
3. **Rate limiting on local models**: Slower than cloud APIs, especially on CPU-only systems
4. **Memory usage**: Large models may cause system slowdowns

## Changelog

- **2025-02**: Initial guide for self-hosted browser-use with Ollama
