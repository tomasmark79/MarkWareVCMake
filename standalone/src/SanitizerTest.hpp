
// MIT License
// Copyright (c) 2024-2025 Tomáš Mark

// sanitizer test
namespace sanitizerTest {
  void scream() {
    char cS[2];
    cS[3] = 'a';
    int* cSA = new int[3];
    delete[] cSA;
    cSA[22] = 0;
  }
}  // namespace sanitizerTest