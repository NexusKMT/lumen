from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "SKILL.md"


class SkillPortabilityTests(unittest.TestCase):
    def setUp(self):
        self.text = SKILL.read_text(encoding="utf-8")
        self.readme = (ROOT / "README.md").read_text(encoding="utf-8")

    def test_frontmatter_is_minimal_and_named(self):
        self.assertTrue(self.text.startswith("---\n"))
        frontmatter, _, _ = self.text[4:].partition("\n---\n")
        self.assertRegex(frontmatter, r"(?m)^name:\s+lumen\s*$")
        self.assertRegex(frontmatter, r"(?m)^description:\s+\S.+$")
        self.assertEqual(ROOT.name, "lumen")

    def test_core_workflow_is_agent_neutral(self):
        forbidden = (
            r"\bcodex\s+mcp\b",
            r"\bCODEX_HOME\b",
            r"~/.codex",
            r"\bscripts/",
        )
        for pattern in forbidden:
            self.assertIsNone(
                re.search(pattern, self.text, flags=re.IGNORECASE),
                msg=f"SKILL.md contains agent-specific dependency: {pattern}",
            )

        self.assertIn("host agent", self.text.lower())
        self.assertIn("live schema", self.text.lower())

    def test_installation_is_host_neutral(self):
        self.assertIn("AGENT_SKILLS_DIR", self.readme)
        self.assertNotRegex(self.readme, r"~/.codex|CODEX_HOME|codex\\s+mcp")

    def test_references_are_present(self):
        for relative_path in (
            "references/exa.md",
            "references/firecrawl.md",
            "references/evidence-index.md",
            ):
                self.assertTrue((ROOT / relative_path).is_file(), relative_path)

    def test_references_require_live_runtime_resolution(self):
        for relative_path in ("references/exa.md", "references/firecrawl.md"):
            text = (ROOT / relative_path).read_text(encoding="utf-8").lower()
            self.assertIn("live tool schema", text, relative_path)

    def test_custom_runtime_scripts_are_not_required(self):
        scripts_dir = ROOT / "scripts"
        self.assertFalse(scripts_dir.exists())


if __name__ == "__main__":
    unittest.main()
