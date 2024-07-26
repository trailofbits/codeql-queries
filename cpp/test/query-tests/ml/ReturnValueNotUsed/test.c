#include "../../../include/ggml/ggml-alloc.h"

void use(ggml_gallocr_t graph) {
  // Operations on graph.
  ggml_gallocr_free(graph);
}

int bad() {
  ggml_gallocr_new(0);
  return 0;
}

void good() {
  ggml_gallocr_t graph = ggml_gallocr_new(0);
  ggml_gallocr_free(graph);
}

int alsoGood() {
  use(ggml_gallocr_new(0));
  return 0;
}

int main(int argc, char** argv) {
  bad();
  good();
  return alsoGood();
}
