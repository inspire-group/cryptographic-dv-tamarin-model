# Artifact Appendix

Paper title: Cryptographically-Secured Domain Validation

Requested Badge(s):
  - [X] **Available**
  - [X] **Functional**
  - [X] **Reproduced**

## Description
This artifact relates to the paper: Cimaszewski, G. H., Birge-Lee, H., Krähenbühl, C., Wang, L., Gable, A., & Mittal, P. (2026). Cryptographically-Secured Domain Validation. Proceedings on Privacy Enhancing Technologies, 2026(1).

It contains the Tamarin model used to prove the security properties of the proposed CAA security tag.

### Security/Privacy Issues and Ethical Concerns

This artifact does not have any security or privacy concern since it only consists of a Tamarin model description and a Dockerfile to evaluate this model regarding its security properties.

## Basic Requirements

### Hardware Requirements

The artifact can run on a laptop (No special hardware requirements).
The authors were able to complete all proofs on a laptop running a VM with 3 dedicated CPU cores (13th Gen Intel(R) Core(TM) i7-1365U) and 24000MB of RAM.

### Software Requirements

The artifact was evaluated on Ubuntu 24.04 since it allows for an easy installation of the Tamarin prover and its dependencies: maude (v3.2 or higher), haskell-stack (v2.9.3.1 or higher), graphviz (v2.43.0 or higher).
We provide a Dockerfile to install the Tamarin prover including the above dependencies and tested the docker container using Docker 28.2.2.

### Estimated Time and Storage Consumption

The expected runtime and storage overhead for running the Tamarin proofs on the previously mentioned hardware are as follows:
- Building docker container: 1 min (731 MB)
- Security proofs without debug restrictions: 170 min (2 MB)
- Security and executability proofs with debug restrictions: 218 min (2 MB)

## Environment

### Accessibility

The Tamarin source code, Dockerfile, and Tamarin prover binary are available in a public github repository: https://github.com/inspire-group/cryptographic-dv-tamarin-model/tree/pets-2026

### Set up the environment

The environment setup consists of: (1) cloning the repository, and (2) building the Tamarin prover docker container.

```bash
git clone -b pets-2026 https://github.com/inspire-group/cryptographic-dv-tamarin-model.git
cd cryptographic-dv-tamarin-model
docker build -t tamarin .
```

### Testing the Environment

Launch the Docker container, attach the current working directory (i.e., run from the root of the cloned git repository) as a volume, set the context to be that volume, and prove Tamarin lemmas of a simple test model (`test.sphty`).
Lemmas can be proven either (1) automatically with `--prove` or (2) interactively via the Tamarin web interface at https://localhost:3001 with `interactive`.

```bash
# automatic proof
docker run -t --net=host -v .:/workspace tamarin --prove --quit-on-warning test.spthy

# interactive proof: select "TestModel" and then click the key "s" to prove all lemmas
docker run -t --net=host -v .:/workspace tamarin interactive --quit-on-warning .
```

The automatic proof should contain the following two lines at the end of the proof output:

```
  DummyExistenceLemma (exists-trace): verified (2 steps)
  DummyForAllLemma (all-traces): verified (2 steps)
```

And the interactive proof should highlight both lemmas (DummyExistenceLemma and DummyForAllLemma in green showing that Tamarin was able to verify them.

## Artifact Evaluation

### Main Results and Claims

The Tamarin model shows that the claimed security properties of a DNSSEC-enabled domain owner described in the formal analysis section of the paper (secure issuance and downgrade prevention) hold with respect to our model.
Additionally, the model shows that the protocol is executable and that attacks are possible if keys are leaked or DNS entries are not protected.

#### Main Result 1: Secure Issuance

The security property "secure issuance" claims that if a CA supports cryptographic DV, they will not issue a certificate for a Dolev-Yao adversary.
We prove this property with the following three lemmas showing that the CA only accepts certificate requests from the account created by the rightful domain owner, if ...
- ... the domain owner creates a CAA security tag requiring secure lookup of a DNS nonce provided by the CA (SecureRecordChangeIssuance)
- ... the domain owner creates a CAA security tag containing their account URI (KnownAccountSpecifierIssuance)
- ... the domain owner creates a CAA issue tag containing their account URI (CaaIssueAccountUriIssuance)

#### Main Result 2: Downgrade Prevention

The security property "downgrade protection", i.e., a Dolev-Yao adversary cannot use a secure but non-participating CA to obtain a fake certificate, is proven through the lemma NoFakeCertificateIssuance.
This lemma states that if a certificate is issued by a secure CA, the domain owner enables DNSSEC, and the domain owner issued a CAA record stipulating cryptographic DV, this certificate must contain the domain owner's legitimate TLS key.

#### Main Result 3: Model Executability

The model contains 21 "existence" lemmas that show that a domain owner can actually obtain certificates, e.g., `LegitimateCaaAcceptedForVictimDomain`, and lemmas that show possible attacks, e.g., `AdversaryCanAuthenticateIfDnssecKeyIsRevealed`.

### Experiments

There are two experiments that produce these three results.
The difference between the experiments are the model restrictions and which lemmas are proven.

#### Experiment 1: Prove all lemmas with visualization restriction

The first experiment takes around 218 minutes to complete and proves all security lemmas and their dependent lemmas (results 1 and 2) as well as the executability and attack lemmas (result 3).

It is run as follows:

```bash
docker run -t --net=host -v .:/workspace tamarin --quit-on-warning --derivcheck-timeout=0 --prove model.spthy
```

Note that `--derivcheck-timeout=0` ensures that pre-proof Tamarin check does not time out.

The output should end with a list of all proven lemmas and each lemma must end with "verified (X steps)" showing that the Tamarin prover succeeded in verifying this lemma.
For example:

```
  SecureDnssecChainNewLabelHasSecureApex (all-traces): verified (247 steps)
  HasApexDomain (all-traces): verified (35 steps)
  ...
```

#### Experiment 2: Prove security lemmas without visualization restriction

The second experiment takes around 170 minutes to complete and proves all security lemmas and their dependent lemmas (results 1 and 2) without the so-called "debug restrictions".
These restrictions are used to produce clearer proof graphs in the interactive mode but may inadvertently restrict the adversary and thus not produce the desired security proofs.
Note that there is no need to run the executability and attack lemmas (result 3) without these restrictions since any lemma that was proven with these restrictions in experiment 1 would naturally also be valid without these restrictions, i.e., restrictions can only reduce the set of possible execution traces and not produce new traces.

It is run as follows:

```bash
docker run -t --net=host -v .:/workspace tamarin --quit-on-warning --derivcheck-timeout=0 -Dnodebugrestrictions -Donlysecuritylemmas --prove model.spthy
```

Analogous to experiment 1, the output should end with a list of all proven lemmas.
For example:

```
  SecureDnssecChainNewLabelHasSecureApex (all-traces): verified (247 steps)
  HasApexDomain (all-traces): verified (35 steps)
  ...
```

## Limitations

There are no limitations with respect to the Tamarin model made available in this artifact, i.e., the complete model is made available.

## Notes on Reusability

The Tamarin model could be extended with additional prootocol details, such as precise interaction during creation of CA accounts and the communication of domain validation parameters, such as DNS nonces.
Furthermore, it could be extended to not only consider DNSSEC, but also the secure retrieval of DNS records through secure channels to authoritative nameservers (see Section 4.3, paragraph "Secure Channels for authenticated DNS lookup" in the paper).
