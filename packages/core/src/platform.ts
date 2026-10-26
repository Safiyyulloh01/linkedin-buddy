/**
 * Cross-platform runtime initialization.
 * Normalizes Android/Termux environments to linux platform semantics for Playwright compatibility.
 */
if (typeof process !== "undefined" && process.platform === "android") {
  Object.defineProperty(process, "platform", { value: "linux" });
}

export {};
