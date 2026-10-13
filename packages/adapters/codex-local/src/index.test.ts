import { describe, expect, it } from "vitest";
import {
  CODEX_LOCAL_FAST_MODE_SUPPORTED_MODELS,
  DEFAULT_CODEX_LOCAL_MODEL,
  isCodexLocalFastModeSupported,
  models,
} from "./index.js";

describe("codex local adapter metadata", () => {
  it("advertises current GPT-5.6 Codex-capable OpenAI models by default", () => {
    const modelIds = models.map((model) => model.id);

    expect(DEFAULT_CODEX_LOCAL_MODEL).toBe("gpt-5.6");
    expect(modelIds.slice(0, 4)).toEqual([
      "gpt-5.6",
      "gpt-5.6-sol",
      "gpt-5.6-terra",
      "gpt-5.6-luna",
    ]);
    expect(isCodexLocalFastModeSupported(DEFAULT_CODEX_LOCAL_MODEL)).toBe(true);
    expect(modelIds).not.toContain("gpt-5.3-codex");
  });

  it("retains the fork's legacy model entries without duplicates", () => {
    const modelIds = models.map((model) => model.id);

    expect(new Set(modelIds).size).toBe(modelIds.length);
    for (const model of ["gpt-5.5", "gpt-5.4"]) {
      expect(modelIds.filter((id) => id === model)).toHaveLength(1);
      expect(CODEX_LOCAL_FAST_MODE_SUPPORTED_MODELS).toContain(model);
      expect(isCodexLocalFastModeSupported(model)).toBe(true);
    }
  });
});
