#include "../../../include/ggml/ggml-alloc.h"

int condition(int flag) {
  return (flag == 1);
}

void use(ggml_gallocr_t graph) {
  // Operations on graph.
}

int bad(int flag) {
  ggml_gallocr_t graph = ggml_gallocr_new(0);

  if (condition(flag)) {
    // `graph` may be freed here.
    ggml_gallocr_free(graph);
  }

  // Potential use-after-free here.
  use(graph);
  ggml_gallocr_free(graph);
  return 0;
}

ggml_gallocr_t good() {
  ggml_gallocr_t graph = ggml_gallocr_new(0);
  return graph;
}

int alsoGood(int flag) {
  ggml_gallocr_t graph0 = ggml_gallocr_new(0);
  ggml_gallocr_t graph1 = ggml_gallocr_new(0);

  if (condition(flag)) {
    // `graph0` may be freed here
    ggml_gallocr_free(graph0);
    // but is immediately re-assigned here.
    graph0 = graph1;
  }

  // `graph0` is always allocated here.
  use(graph0);

  ggml_gallocr_free(graph0);
  ggml_gallocr_free(graph1);

  return 0;
}

int main(int argc, char** argv) {
  int flag = 0;
  
  ggml_gallocr_t graph = good();
  bad(flag);

  if (condition(flag)) {
    ggml_gallocr_free(graph);
  } else {
    ggml_gallocr_free(graph);
  }

  return alsoGood(flag);
}
