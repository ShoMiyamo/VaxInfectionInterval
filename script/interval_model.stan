data {
  int N;
  int K;
  real X[N];
  real Y[N];
  int<lower=1, upper=K> GID[N];
}

parameters {
  real<lower=0, upper=5> mu0;
  real<lower=0, upper=5> a;
  real<lower=0, upper=1> b;
  real<lower=0, upper=5> mu[K];
  real<lower=0, upper=5> s_mu0;
  real<lower=0> s_Y;
}

model {  
  for (k in 1:K) {
    mu[k] ~ normal(mu0, s_mu0);
    }
    mu ~ normal (2.5, 1);
    a ~ normal (2.5, 1);
    b ~ student_t (4, 0.05, 0.1);
    s_mu0 ~student_t(4, 0, 0.5);

  for (n in 1:N)
      Y[n] ~ normal(mu[GID[n]] / (1 + a*exp(-b*X[n]) ), s_Y);
}

