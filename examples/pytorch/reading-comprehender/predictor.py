# WARNING: you are on the master branch; please refer to examples on the branch corresponding to your `cortex version` (e.g. for version 0.21.*, run `git checkout -b 0.21` or switch to the `0.21` branch on GitHub)

import torch
from allennlp.predictors.predictor import Predictor as AllenNLPPredictor


class PythonPredictor:
    def __init__(self, config):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        print(f"using device: {self.device}")

        cuda_device = -1
        if self.device == "cuda":
            cuda_device = 0

        self.predictor = AllenNLPPredictor.from_path(
            "https://storage.googleapis.com/allennlp-public-models/bidaf-elmo-model-2018.11.30-charpad.tar.gz",
            cuda_device=cuda_device,
        )

    def predict(self, payload):
        prediction = self.predictor.predict(
            passage=payload["passage"], question=payload["question"]
        )
        return prediction["best_span_str"]
