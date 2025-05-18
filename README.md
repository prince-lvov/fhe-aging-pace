# Aging Pace Estimation Using Fully Homomorphic Encryption

Biological age reflects the condition and functionality of a person’s body systems, indicating how well or poorly they are aging. In contrast, chronological age simply counts the number of years since birth. Unlike chronological age, biological age can vary significantly between individuals of the same age due to factors such as genetics, lifestyle, environment, and disease. Understanding a person’s biological age—and more specifically, the *pace* at which they are aging—provides crucial insight into their long-term health risks and potential lifespan. This information can guide personalized interventions to slow aging, prevent disease, and improve quality of life.

## DunedinPACE

DunedinPACE is the first DNA methylation biomarker designed to measure the *pace* of biological aging. It acts as a "speedometer" for aging, estimating the rate of aging from a single blood sample. DunedinPACE values indicate whether an individual is aging faster or slower than the normative rate of one year of biological aging per chronological year.

## Importance of FHE for Medical Data

Medical privacy is essential to protect individuals from discrimination, stigma, and unauthorized use of sensitive health data. Breaches in medical privacy can lead to identity theft, insurance denial, or job loss. Fully Homomorphic Encryption (FHE) enables computation on encrypted data, ensuring personal health information remains confidential throughout the entire process. This allows valuable medical insights to be derived without ever exposing raw data—offering both privacy and utility.

## FHE DunedinPACE

To enable aging pace estimation on encrypted data, we implemented an FHE version of the DunedinPACE model. To simplify computation, we used a version of the model without a linear component.

## FHE DunedinPACE with High Precision

When converting floating-point numbers to integers (a requirement for FHE), precision is typically lost. To avoid this, we implemented a high-precision version of the model using a technique similar to `Veltkamp splitting`. Each float is split into two parts (high and low), which increases the number of required computations (from one np.dot to four combinations of high/low multiplications). However, this yields a significant improvement in precision.

## Data

1. DunedinPACE model parameters were extracted from the official R implementation: [DunedinPACE GitHub](https://github.com/danbelsky/DunedinPACE/tree/main), and saved to `data/dunedin_pace_data.json`
2. We used the `GSE40279` dataset. To reproduce our results, download [GSE40279\_average\_beta.txt](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE40279) and place it in the `data` folder (also you need to unzip file)

## Results

We evaluated all three models on `656 samples` from the `GSE40279` dataset (for each sample, we measured the pace of aging). For FHE models both inference time and numerical deviation were compared relative to the non-FHE implementation.

### Standard Python DunedinPACE

Our pure Python (non-FHE) implementation matches the original R (you can get pace values by run `dunedin_pace.R`) and [pyaging](https://github.com/rsinghlab/pyaging/tree/main) versions closely (MAE \~ 1e-4) and avoids using linear models or torch library.

### FHE DunedinPACE

* About 10× slower than the non-FHE version (comparable to our previous FHE projects).
* Small deviation from the non-FHE version (MAE \~ 1e-4).

### FHE DunedinPACE High Precision

* Approximately 40× slower than the non-FHE version (also comparable to previous projects).
* Almost identical results to the non-FHE version (MAE \~ 1e-7).

## Challenges

### Inputset Generation for Maximum Precision

To achieve high precision, we experimented with large scale factors when converting floats to integers. This occasionally triggered `NoParametersFound` errors during circuit compilation. The error seems to occur when intermediate values exceed FHE max value limits. It would be helpful if error messages included more specific details.

### Direct Circuits and Output Type Inference
To avoid compilation issues, we wanted to manually define input and output types and use direct circuits. However, there’s currently no way to specify the circuit’s output type explicitly. Error also occurred when output types (e.g., scalar int) didn’t match input types (e.g., arrays). More examples in documentation involving array inputs would be very helpful.

## Final Thoughts

Our implementation of DunedinPACE using FHE is a promising step toward privacy-preserving aging pace estimation. The simple FHE version offers good accuracy for most applications, while the high-precision version provides even closer results to the original model.

👉 Try our Hugging Face demo: [https://huggingface.co/spaces/horaizon27/aging\_pace](https://huggingface.co/spaces/horaizon27/fhe_aging_pace)

---

## Using the Repository

1. Build Docker container using files from `docker` folder
2. Clone this repository
3. Download `GSE40279_average_beta.txt` file from `GSE40279`  [dataset](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE40279) to the `data` folder
4. Run `main.ipynb` (adjust constants if needed)