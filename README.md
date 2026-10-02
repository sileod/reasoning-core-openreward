# reasoning-core OpenReward environment

This folder contains an OpenReward-compatible ORS environment for [`reasoning-core`](https://github.com/sileod/reasoning-core/).

## Files

- `server.py`: OpenReward environment server implementation.
- `requirements.txt`: Python dependencies for local/dev builds.
- `Dockerfile`: Container spec used by OpenReward deployment.

## Local run

```bash
cd reasoning_core/openreward/reasoning_core_env
pip install -r requirements.txt
python server.py
```

## Quick local smoke test

```python
from openreward import OpenReward

or_client = OpenReward()
env = or_client.environments.get(name="reasoningcore", base_url="http://localhost:8080")

print(env.list_splits())
print(env.list_tools())
print(env.list_tasks("train")[:1])
```

## Configuration

Set optional environment variables before launch:

- `RC_NUM_TRAIN` (default `500`)
- `RC_NUM_TEST` (default `50`)
- `RC_SEED` (default `0`)
- `RC_PASS_THRESHOLD` (default `0.98`)
- `RC_HF_DATASET` (default `reasoning-core/procedural-pile`)
- `RC_HF_REVISION` (optional tag or commit of the dataset, to pin the tasks)
- `RC_HF_CONFIG` (optional dataset config name)

The task order is deterministic for fixed values of these variables.

## Notes

- The environment exposes a single `answer` tool.
- The tool returns a human-readable result with a rounded reward (`reward=0.000` format).
- "Accepted" defaults to `reward >= 0.98` (configurable via `RC_PASS_THRESHOLD`).
- The tool accepts either plain-text answers or XML-wrapped answers (`<answer>...</answer>`), matching common evaluator output formats.
- By default, tasks are the first rows of [`reasoning-core/procedural-pile`](https://huggingface.co/datasets/reasoning-core/procedural-pile) (pre-shuffled, all task families within the first few hundred rows). Rows whose task has no scorer in the installed `reasoning-core` are skipped. If the dataset has no native test split, test tasks are sampled from train.
- If Hugging Face loading fails, the environment falls back to deterministic procedural task generation.
