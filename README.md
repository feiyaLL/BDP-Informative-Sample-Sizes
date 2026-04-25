# A Nonparametric Bayesian Shrinkage Estimator for Binomial Data under Informative Sample Sizes

R code for the manuscript by Lufeiya Liu (lul115@pitt.edu), Spring 2026.

This project extends Zhang & Liu (2012, *Canadian Journal of Statistics*)
"Nonparametric hierarchical Bayes analysis of binomial data via Bernstein
polynomial priors" by adding a log-normal observation process for the sample
sizes `N_i`:

```
log(N_i) | theta_i ~ Normal(alpha + beta * theta_i, sigma^2)
```

When `beta = 0`, the model reduces exactly to Zhang and Liu's standard BDP.

## Headline Results

| Application       | Method                  | TSE*  | Notes                                |
|-------------------|-------------------------|-------|--------------------------------------|
| Baseball (n=567)  | Standard BDP            | 0.627 | Reproduction of Zhang & Liu (2012)   |
| Baseball (n=567)  | NPEB (Brown 2008)       | 0.508 | Previous best on this benchmark      |
| Baseball (n=567)  | **Informative BDP**     | **0.455** | `K_max=1200`, `beta_hat=17.53` |
| Stack Overflow    | Standard BDP            | 0.786 | Applied to Stack Overflow data       |
| Stack Overflow    | **Informative BDP**     | **0.766** | `K_max=200`, `beta_hat=1.23`   |

## Files

- `BDP_Informative_N_Final.Rmd` — main R Markdown file containing all code
- `figs/` — output directory for manuscript figures (created at runtime)
- `results/` — output directory for saved RData files (created at runtime)
- `data/` — directory for input data (Brown's MLB data, Stack Overflow query results)

## Code Structure

The Rmd file is organized into eight sections:

1. **Core Functions** — `bdp_mcmc()`, `informative_bdp_lognormal()`, `stein_estimator()`, `compute_tse_star()`
2. **Reproduction** — Zhang & Liu (2012), Table 1, four scenarios
3. **Baseball Application** — including K_max sensitivity sweep
4. **Stack Overflow Application** — including K_max sensitivity check
5. **Simulation Study** — five scenarios, 30 replicates
6. **Structural Diagnostic** — Tests A-D from Supplement E
7. **Errors-in-Variables Verification** — numerical check on baseball data
8. **Figures** — generates `FigD1_traces.pdf`, `FigE1_crossover.pdf`,
   `FigE2_shrinkage.pdf`, `FigF1_density_reproduction.pdf`

## Reproducing the Manuscript Results

### Quick start (~30 minutes)

If you only want to verify the headline baseball result:

1. Place `monthly_data_2005_commas.TXT` in `data/`
2. Run sections 1, 2, and 3 of the Rmd

### Full reproduction (~15 hours)

1. Place data files in `data/`
2. Run all sections, including the K_max sensitivity sweep (Section 3.5)
   and 30-replicate simulation (Section 5)
3. The diagnostic tests in Section 6 add another ~2 hours

### Saving intermediate results

Long-running chunks (`eval=FALSE` by default) save to `results/`:

- `results/baseball_kmax_sweep.RData` — K_max ∈ {200, 400, 800, 1200}
- `results/sim_30rep_results.RData` — 5 scenarios × 30 replicates

Set `eval=TRUE` to run; otherwise the script will load saved RData if present.

## MCMC Settings

- 20,000 iterations after 5,000 burn-in (real data applications)
- 8,000 iterations after 2,000 burn-in (simulation replicates)
- `K_max` defaults to 200; baseball headline uses `K_max = 1200`
  following the sensitivity sweep
- All sampler runs use `seed = 42` unless noted otherwise

## Data

- **Brown's 2005 MLB monthly batting data** (Brown 2008): place
  `monthly_data_2005_commas.TXT` in `data/`. The file is publicly available.
- **Stack Overflow 2023 data**: extracted via the SQL query in
  `data/stackoverflow_query.sql` from the public Stack Exchange Data Explorer
  (https://data.stackexchange.com/stackoverflow). After filtering to users
  with at least 11 answers in each half of 2023, n = 2,491 users remain.

## R Packages

Standard R only:
- `stats` (built-in)
- `graphics` (built-in)
- `knitr` (for rendering only)

No additional packages are required to run the samplers themselves.

## Citation

If you use this code, please cite the manuscript and the original Zhang & Liu (2012):

- Zhang, T. and Liu, J. S. (2012). Nonparametric hierarchical Bayes analysis
  of binomial data via Bernstein polynomial priors. *Canadian Journal of
  Statistics*, 40, 328–344.
