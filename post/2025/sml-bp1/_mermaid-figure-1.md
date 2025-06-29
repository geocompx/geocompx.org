```{mermaid index-1}
%%| fig-width: 8
%%| fig-height: 6.5
%%| echo: false
%%| eval: false
%%| fig-cap: "A possible workflow of the spatial machine learning task."
flowchart TB
    A[Data] --> B(Model specification)
    B --> C(Resampling #1)
    B --> D(Resampling #2)
    B --> E(Resampling #...)
    B --> F(Resampling #N)
    C --> G(Evaluation)
    D --> G
    E --> G
    F --> G
    G --> H[Prediction]
    H --> I[Area of applicability]
```