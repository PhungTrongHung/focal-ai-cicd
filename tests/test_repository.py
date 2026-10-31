from pathlib import Path
import ast

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

def test_focal_source_exists():
    assert (SRC / "train.py").is_file()
    assert (SRC / "test.py").is_file()

def test_train_entrypoint_is_valid_python():
    code = (SRC / "train.py").read_text(
        encoding="utf-8"
    )
    ast.parse(code)
    assert "def main_train(" in code

def test_test_entrypoint_is_valid_python():
    code = (SRC / "test.py").read_text(
        encoding="utf-8"
    )
    ast.parse(code)
    assert "def main_test(" in code