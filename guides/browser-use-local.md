# Browser-Use: Browser Automation for Product Audits

A comprehensive guide to running [browser-use](https://github.com/browser-use/browser-use) for automated product testing, UI audits, and screenshot verification.

## Setup Options

| Option | Best For | Cost | Vision Support |
|--------|----------|------|----------------|
| **Gemini 2.5 Flash** | Most users | Free (250 req/day) | Excellent |
| **Gemini 2.5 Flash-Lite** | High volume | Free (1000 req/day) | Excellent |
| **Gemini 3 Flash Preview** | Bleeding edge | Free (limited) | Excellent |
| **Ollama (local)** | Full privacy | Free | Limited |

**Recommendation**: Use Gemini 2.5 Flash for best balance of quality and free quota. Use Ollama only if you need fully offline operation.

> **Note**: Gemini 2.0 Flash is deprecated and will be shut down on March 31, 2026.

---

## Option 1: Gemini (Recommended)

### Why Gemini?

- **Native vision**: Built for screenshot-based browser automation
- **Fast**: ~225ms latency vs seconds for local models
- **Accurate**: 70%+ accuracy on browser automation benchmarks
- **Free tier**: 250-1000 requests/day depending on model
- **No hardware**: No GPU or high RAM needed

### Free Tier Limits (as of February 2026)

| Model | RPM | RPD | TPM |
|-------|-----|-----|-----|
| `gemini-2.5-flash-lite` | 15 | 1,000 | 250,000 |
| `gemini-2.5-flash` | 10 | 250 | 250,000 |
| `gemini-2.5-pro` | 5 | 100 | 250,000 |

*Limits apply per project (not per API key). Daily quotas reset at midnight Pacific Time.*

> **Note**: December 2025 quota reductions (50-80%) may affect actual limits. Check [AI Studio](https://aistudio.google.com/usage) for your current quota.

### Setup

1. **Get API Key**: Go to [Google AI Studio](https://aistudio.google.com/) and create an API key

2. **Install browser-use**:
```bash
pip install browser-use langchain-google-genai
playwright install chromium
```

3. **Set environment variable**:
```bash
export GOOGLE_API_KEY="your-api-key-here"
```

4. **Create your audit script** (`audit.py`):
```python
import asyncio
from browser_use import Agent
from langchain_google_genai import ChatGoogleGenerativeAI

async def run_audit():
    llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash")

    agent = Agent(
        task="Navigate to https://example.com, take a screenshot, and describe what you see",
        llm=llm,
        use_vision=True,
        generate_gif=True,
        save_conversation_path="audit.json",
    )
    result = await agent.run(max_steps=15)
    return result

if __name__ == "__main__":
    result = asyncio.run(run_audit())
    print(result)
```

5. **Run it**:
```bash
python audit.py
```

### Gemini 3 Flash Preview (Experimental)

For the latest capabilities, try the Gemini 3 Flash Preview:

```python
llm = ChatGoogleGenerativeAI(model="gemini-3-flash-preview")
```

> **Warning**: Preview models have stricter rate limits and may change without notice.

### Direct Vision Analysis (No browser-use)

For simpler screenshot analysis without browser automation:

```python
from google import genai
from playwright.sync_api import sync_playwright

client = genai.Client()

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page(viewport={"width": 1440, "height": 900})

    page.goto("https://example.com")
    screenshot = page.screenshot(type="png")

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=[
            {"text": "Describe this webpage and identify any UI issues"},
            {"inline_data": {"mime_type": "image/png", "data": screenshot}}
        ]
    )
    print(response.text)
```

---

## Option 2: Ollama (Fully Local)

Use this only if you need complete privacy with no cloud calls.

### Requirements

- 16GB+ RAM (32GB recommended)
- 12GB+ storage for models
- Python 3.11+

### Setup

```bash
# Install Ollama
brew install ollama  # macOS
# or: curl -fsSL https://ollama.com/install.sh | sh  # Linux

# Start server and pull model
ollama serve
ollama pull qwen2.5:7b

# Install browser-use
pip install browser-use langchain-ollama
playwright install chromium
```

### Usage

```python
import asyncio
from browser_use import Agent
from langchain_ollama import ChatOllama

async def run_audit():
    agent = Agent(
        task="Navigate to https://example.com and describe the page",
        llm=ChatOllama(model="qwen2.5:7b", num_ctx=32000),
        max_actions_per_step=3,
        tool_call_in_content=False,
        generate_gif=True,
    )
    result = await agent.run(max_steps=15)
    return result

asyncio.run(run_audit())
```

### Local Model Options

| Model | Size | Notes |
|-------|------|-------|
| `qwen2.5:7b` | 6GB | Good balance |
| `qwen2.5:14b` | 9GB | Better reasoning |
| `qwen2.5vl:7b` | 6GB | Vision support (experimental) |
| `deepseek-r1:7b` | 5GB | Strong reasoning |

### Limitations

- Vision support in browser-use may have `supports_vision=False` hardcoded for Ollama
- Slower than cloud models (2-10+ seconds vs 225ms)
- Requires significant RAM

---

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
        llm=ChatGoogleGenerativeAI(model="gemini-2.5-flash"),
        use_vision=True,
        generate_gif="checkout_flow.gif",
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
        llm=ChatGoogleGenerativeAI(model="gemini-2.5-flash"),
        use_vision=True,
        generate_gif="form_validation.gif",
    )
    return await agent.run(max_steps=20)
```

### Responsive Design Check

```python
from browser_use import Agent, Browser

async def check_responsive():
    browser = Browser(headless=False, window_size=(375, 812))  # iPhone X

    agent = Agent(
        task="""
        Navigate to https://example.com and:
        1. Screenshot the mobile layout
        2. Check if navigation is accessible
        3. Verify text is readable
        4. Report any overflow or layout issues
        """,
        llm=ChatGoogleGenerativeAI(model="gemini-2.5-flash"),
        browser=browser,
        use_vision=True,
        generate_gif="mobile_check.gif",
    )
    return await agent.run(max_steps=15)
```

---

## Recording & Evidence

### GIF Recording

```python
agent = Agent(
    task="Your task here",
    llm=llm,
    generate_gif=True,  # or "path/to/output.gif"
)
```

### Save Conversation History

```python
agent = Agent(
    task="Your task here",
    llm=llm,
    save_conversation_path="audit_log.json",
)
```

### Export to Jupyter Notebook

```python
from browser_use import export_to_ipynb

notebook_path = export_to_ipynb(agent, "product_audit.ipynb")
```

---

## Web UI Alternative

For a visual interface:

```bash
git clone https://github.com/browser-use/web-ui.git
cd web-ui

# Docker (recommended)
docker compose up --build
# Access at http://localhost:7788
# VNC at http://localhost:6080/vnc.html
```

---

## Available Browser Actions

| Action | Description |
|--------|-------------|
| `navigate` | Go to a URL |
| `click` | Click an element |
| `input` | Type text |
| `scroll` | Scroll the page |
| `screenshot` | Capture current state |
| `wait` | Pause |
| `go_back` | Navigate back |
| `extract` | Extract structured data |
| `evaluate` | Execute JavaScript |

---

## Resources

- [browser-use GitHub](https://github.com/browser-use/browser-use)
- [browser-use Documentation](https://docs.browser-use.com)
- [Google AI Studio](https://aistudio.google.com/) - Get Gemini API key
- [Gemini Models Documentation](https://ai.google.dev/gemini-api/docs/models)
- [Ollama](https://ollama.com)

---

## Changelog

- **2026-02**: Updated to Gemini 2.5 Flash (2.0 Flash deprecated). Added Gemini 3 Flash Preview.
- **2025-02**: Initial guide with Gemini over Ollama recommendation.
