# Setup

Install the Tamarin prover by following the [installation instructions](https://tamarin-prover.com/manual/master/book/002_installation.html).

# Running the Prover Interactively
Run the tamarin prover with the following command: `tamarin-prover interactive --derivcheck-timeout=0 model.spthy --quit-on-warning`

`--derivcheck-timeout=0` is necessary to prevent tamarin from aborting the model early due to the long loading time.

`--quit-on-warning` ensures that modeling error will not only raise an alarm but also stop the tamarin prover.

In the Tamarin web interface, use the shortcut "a" to prove a single selected lemma and the shortcut "s" to prove all lemmas in the model.

# Running the Prover Automatically
Run the tamarin prover with the following command: `tamarin-prover --derivcheck-timeout=0 model.spthy --quit-on-warning --prove=[lemma-to-prove]`

If no lemma is provided (`--prove`), all lemmas in the theory are proven.

`--derivcheck-timeout=0` is necessary to prevent tamarin from aborting the model early due to the long loading time.

`--quit-on-warning` ensures that modeling error will not only raise an alarm but also stop the tamarin prover.

The model contains two flags that can be passed to the prover using the syntax `-D[flagname]`:

- The `-Dnodebugrestrictions` flag disables several restrictions which are only used to improve the clarify of the visual Tamarin output but do not impact the security properties of the system, e.g., prevent Tamarin from invoking rules that create identical DS records, which is not problematic from a protocol perspective but makes it hard to see visual patterns.

- The `-Donlysecuritylemmas` flag keeps all lemmas used to prove the security properties of our protocol but removes lemmas that are only used to prove the executability of the protocol and the presence of attacks.

## Prover Performance
Below is a table with the number of steps and runtime required to prove all lemmas (12 helper, 6 security, and 14 executability lemmas). For security lemmas, we also include the performance of a run without the debug restrictions (marked with an asterisk). Note that for the executability and attack lemmas, debug restrictions are not problematic, since these lemmas provide us with a concrete protocol trace even with the additional restrictions.

The performance evaluation was performed on a VM running with 3 CPU cores (13th Gen Intel(R) Core(TM) i7-1365U) and 24000MB of RAM.

| Lemma                        | Steps | Runtime         | Steps* | Runtime*       |
|:----------------------------:|:-----:|:---------------:|:------:|:--------------:|
| Helper1                      | 247   | 1256s (20min)   | 247    | 1125s (18min)  |
| Helper2                      | 35    | 1244s (20min)   | 35     | 998s (16min)   |
| Helper3                      | 117   | 1161s (19min)   | 117    | 1055s (17min)  |
| Helper4                      | 82    | 1190s (19min)   | 82     | 1090s (18min)  |
| Helper5                      | 250   | 1184s (19min)   | 250    | 1097s (18min)  |
| Helper6                      | 8     | 1176s (19min)   | 8      | 1123s (18min)  |
| Helper7                      | 135   | 1103s (18min)   | 135    | 990s (16min)   |
| Helper8                      | 359   | 1243s (20min)   | 359    | 1131s (18min)  |
| Helper9                      | 83    | 1183s (19min)   | 83     | 1128s (18min)  |
| Helper10                     | 220   | 1169s (19min)   | 220    | 1054s (17min)  |
| Helper11                     | 1666  | 2409s (40min)   | 1666   | 2228s (37min)  |
| Helper12                     | 1895  | 1229s (20min)   | 1895   | 1239s (20min)  |
| Sec1                         | 390   | 1257s (20min)   | 317    | 1064s (17min)  |
| Sec2                         | 270   | 1162s (19min)   | 270    | 1086s (18min)  |
| Sec3                         | 805   | 1324s (22min)   | 805    | 1245s (20min)  |
| Sec4                         | 2052  | 1836s (30min)   | 2085   | 1701s (28min)  |
| Sec5                         | 3526  | 8109s (135min)  | 3526   | 7491s (124min) |
| Sec6                         | 104   | 1348s (22min)   | 104    | 1220s (20min)  |
| Helper + Sec combined        |       |                 |        | 9506s (158min) |
| Exec1                        | 62    | 1315s (21min)   |        |                |
| Exec2                        | 41    | 1458s (24min)   |        |                |
| Exec3                        | 55    | 1268s (21min)   |        |                |
| Exec4                        | 53    | 1296s (21min)   |        |                |
| Exec5                        | 43    | 1250s (20min)   |        |                |
| Exec6                        | 43    | 1218s (20min)   |        |                |
| Exec7                        | 57    | 1307s (21min)   |        |                |
| Exec8                        | 57    | 1269s (21min)   |        |                |
| Exec9                        | 40    | 1286s (21min)   |        |                |
| Exec10                       | 54    | 1253s (20min)   |        |                |
| Exec11                       | 62    | 1247s (20min)   |        |                |
| Exec12                       | 56    | 1249s (20min)   |        |                |
| Exec13                       | 55    | 1270s (21min)   |        |                |
| Exec14                       | 60    | 1347s (22min)   |        |                |
| Helper + Sec + Exec combined |       | 13370s (222min) |        |                |

Lemma Legend

- Helper1: SecureDnssecChainNewLabelHasSecureApex
- Helper2: HasApexDomain
- Helper3: SecureChainExtendsToOwnZone
- Helper4: SecureChainExtendsToParentZone
- Helper5: SingleDomainOwnerPerZone
- Helper6: SingleZonePerDomain
- Helper7: NoCyclicZonesParentHeuGeneric
- Helper8: ValidDnssecKeySelectedByRoot
- Helper9: SecureChainOwnedByBenignDomainOwner
- Helper10: DnssecKeyValidatedUsingLabelMustHaveDelegationSignerOrRootAncestor
- Helper11: ValidPublicKeyIsNotKnownToAdversaryApexOnly
- Helper12: ValidPublicKeyIsNotKnownToAdversary
- Sec1: SecureRecordChangeIssuance
- Sec2: KnownAccountSpecifierIssuance
- Sec3: CaaIssueAccountUriIssuance
- Sec4: NoFakeCertificateIssuance
- Sec5: OnlyLegitimateDomainOwnerCanAuthenticate
- Sec6: OnlyLegitimateKeyHolderCanIssueCertForPublicKey
- Exec1: CanAuthenticateSecureDomainSld
- Exec2: CanAuthenticateNoDnssecDomainSld
- Exec3: CanAuthenticateNoCaaDomainSld
- Exec4: CanAuthenticateAdversaryDomainSld
- Exec5: LegitimateUriAcceptedForVictimNoDnssecDomainSld
- Exec6: AdversaryUriAcceptedForVictimNoDnssecDomainSld
- Exec7: LegitimateUriAcceptedForVictimNoCaaDomainSld
- Exec8: AdversaryUriAcceptedForVictimNoCaaDomainSld
- Exec9: AdversaryCanAuthenticateNoDnssecDomainSld
- Exec10: AdversaryCanAuthenticateNoCaaDomainSld
- Exec11: NonParticipatingCaDomainOwnerCanAuthenticateIfHsvCriticalBitIsNotSet
- Exec12: FakeCertificateWithoutCriticalFlag
- Exec13: InsecureCaNoDnssecAdversaryCaaAcceptedForVictimDomain
- Exec14: AdversaryCaaAcceptedForVictimDomainWithKeyReveal

# Model

The model is located in [model.spthy](./model.spthy). Note that "secure" CAA tags described in the paper are referred to as "high security validation (HSV)" tags in the model.

## Overview

Below is an overview of the modeled entities and their interactions using Tamarin rules and restrictions.
Relevant rules are referenced in square brackets [[CreateSecureCa](./model.spthy#L119)], and relevant restrictions are referenced in curly brackets {[RegisterSingleCaPerIdentifier](./model.spthy#L34)}.
The rules can broadly be classified into "ground truth" rules which represent the intended behavior, e.g., the DNSSEC public key selected by the legitimate domain owner, and "protocol" rules, which represent knowledge learned from messages received over the network, e.g., checking the validity of a DNSSEC public key based on its DNSSEC chain to the root zone.
On a high level, our model allows the creation of an arbitrary ground truth scenario (DNS hierarchies, levels of DNSSEC support, key compromises) and then proves our desired security properties on the protocol output with respect to the ground truth (e.g., the final security lemma states that if a domain uses DNSSEC (ground truth), the CA will not issue a certificate to the adversary).

### Rules and Restrictions
In Tamarin, rules and restrictions describe the behavior of all entities within the protocol.

#### Entity Setup
Initially, all relevant actors are initialized: Secure [CreateSecureCa,CreateNonParticipatingSecureCa] and insecure [CreateInsecureCaNoDnssec,CreateInsecureCaNoCsrSignatureCheck] CAs, benign domain owners [CreateDomainOwner], and adversaries [CreateAdversary].
For proof simplicity and easier visualization, we only instantiate a single adversary {RegisterSingleAdversary}, but this does not restrict the adversary since they can own an arbitrary number of domains.
Benign domain owners then generate TLS keys [RegisterTlsKeys] and adversaries can either generate TLS keys or use any TLS keys revealed by a domain owner [AdversaryRegisterTlsKey].
Since entities may reveal keys by accident or due to compromise, we add rules for key reveals [RevealDomainOwnerDnssecKey,RevealDomainOwnerTlsKey] and ensure that the adversary has knowledge of all of its keys [AdversaryRevealAllKeys].

For each domain and respective domain owner, the desired DNSSEC + CAA configuration is selected: DNSSEC-protected CAA record [DomainOwnerCreatePopRequest], NSEC proof of non-existence of a secure delegation for the domain [DomainOwnerCreatePoaRequest] (note that this only makes sense if the parent zone has the NSEC3 opt-out bit set, otherwise the NSEC proof would indicate the non-existence of the entire domain), and NSEC proof of the non-existence of a CAA record for this domain [DomainOwnerCreatePopNoCaaRequest].
An adversary can request any configuration for any domain [AdversaryIssueRecords] (but may not be able to generate the desired DNSSEC signatures).

Multiple overlapping setup steps are prevented by the following restrictions: {RegisterSingleCaPerIdentifier,RegisterSingleDnssecKeyPerDomain,RegisterSingleNsecRequest}.

We assume that clients use ACME to request certificates and thus model a simplified version of the ACME interactions between clients and CAs.
Benign domain owners and adversaries create ACME accounts [CreateAccount,AdversaryCreateAccount], which can then be used to create certificate issuance requests [CreateCertIssueRequest,AdversaryCreateArbitraryIssueRequests] (note that the adversary can create certificate issuance requests for any domain and public key).
Finally, benign domain owners create certificate signing requests (CSRs) [CreateCsr].
Adversaries do not need any rule to create CSRs since Tamarin can automatically build them from the adversaries knowledge (e.g., if the domain owners TLS key is revealed).

#### DNS Label Topology

The model allows the creation of arbitrary DNS label topologies, where each label is either the root label [CreateDnssecRoot] or the child of another label.
Note that the string representation of labels are not relevant for our model, hence the DNS label topology "a.b.c, d.b.c" is equivalent to the topology "www.example.com, sub.example.com".
Each created domain is associated with its legitimate owner (either a benign domain owner or an adversary) [CreateDomain,CreateAdversaryDomain].
The parent-child relationship between domains and the DNS root is then established [CreateDnsHierarchy,CreateDnsHierarchyRootCase].

We ensure the validity of the topologies by not allowing self-referencing domains {NoSelfReferencingChildren}, not allowing the root to have a parent domain {NoRootParentDomain}, and by ensuring that all domains have at most one parent domain {SingleParentPerDomain}.
Finally, each domain is owned by one single owner or adversary {RegisterSingleDomainOwnerPerDomain}.

#### DNS Zone Topology

Once the label topology is created, we allocate DNS zones in the topology.
A zone is specified by its apex domain, which is the label closest to the root.
Each label in a zone is owned by the same domain owner, i.e., the zone owner.
As examples in the following explanation, let's consider two domains, where the **apex domains** are highlighted in bold: www.**example**.**com**, **v1**.staging.api.**aws**.**com**.
First, a single root zone is created [AddRootZone] (leading to the action fact IsApexDomain(root, root)), then TLD zones are created [AddZone] (leading to the action facts IsApexDomain(com, com), IsApexDomain(example.com, example.com), IsApexDomain(aws.com, aws.com), IsApexDomain(v1.staging.api.aws.com, v1.staging.api.aws.com)).
After creating the zones, labels within the zone are added to the zone [AddLabel], leading to the action facts IsApexDomain(www.example.com, example.com), IsApexDomain(api.aws.com, aws.com), and IsApexDomain(staging.api.aws.com, aws.com).
We ensure that a domain is not part of multiple zones {SingleZoneOrLabelCreated}.

#### DNSSEC

Each zone may support DNSSEC and select a DNSSEC key pair for their zone singing key [DnssecOptIn] (note that we assume online signing and thus do not model an additional key signing key, but instead directly sign the zone signing key in the DS record).
To protect a domain via DNSSEC, all ancestor domains must also support DNSSEC, which is represented by the action fact SecureChainExtended(domain), which is produced by the rules [StartSecureDnssecChain,ExtendSecureDnssecChainToNewZone,ExtendSecureDnssecChainToNewLabel].
Additionally, we ensure that none of the ancestor domain owners revealed their DNSSEC private key to the adversary {SecureChainDomainOwnersDidNotRevealDnssecKey}.
To reduce proof complexity, we ensure that only a single chain is created for each domain {SingleSecureChainPerDomain}.

Based on this ground truth for DNSSEC support, DNSSEC key delegation (DS records) are created [CreateDsRecord], and appropriate NSEC records are signed [CreateNsecPopRecordBelowZoneCut,CreateNsecPopNoCaaRecordBelowZoneCut,CreateNsecPoaRecord].
Note that our model assumes the closest encloser of a domain for NSEC to be the parent domain [SetClosestEncloser].
Finally, a CA checks the validity of DNSSEC public key by verifying a DS record for each zone transition in the DNS chain from the DNS root [ValidateDnssecKeyAtRoot] for all possible cases:

1. apex (com) -> apex (example.com) transition [ValidateDnssecKeyDelegationSignerWithDsOrRootParent]
2. non-apex (staging.api.aws.com) -> apex (v1.staging.api.aws.com) [ValidateDnssecKeyDelegationSignerWithLabelParent]
3. apex (aws.com) -> non-apex (api.aws.com) [ValidateDnssecKeyChildDomainWithDsOrRootParent]
4. non-apex (api.aws.com) -> non-apex (staging.api.aws.com) [ValidateDnssecKeyChildDomainWithLabelParent]

#### Domain Control Validation
The desired validation method is selected by the domain owner [DomainOwnerValidationMethodDnssecRecordChange,DomainOwnerValidationMethodHttp] or the adversary [AdversaryValidationMethodDnssecRecordChange,AdversaryValidationMethodHttp].
We ensure that each domain owner only selects a single validation method {SelectSingleValidationMethod}.
For the secure-dns-record-change method, the CA creates a validation nonce [CaCreateValidationNonce], which is then signed by the domain owner [SignValidationNonce].

Once the ACME account is created and the desired validation method is selected, the domain owner creates a CAA issue record with their account URI [CreateSignedCaaIssueRecordWithAccountUri], a CAA HSV record with secure-dns-record-change as the validation method [CreateSignedCaaHsvRecordWithDnssecRecordChange], or a CAA HSV record with known-account-specifier (caOwnerID) as the validation method [CreateSignedCaaHsvRecordWithKnownAccountSpecifier].
All three of these CAA records indicate cryptographically secure certificate issuance.
Additionally, a domain owner may create a CAA HSV record without setting the critical flag, which does not indicate secure issuance since it may be ignored by a non-participating CA [CreateSignedNonCriticalCaaHsvRecordWithDnssecRecordChange].
This allows us to show that the critical bit is crucial to provide a secure incremental deployment.

The implementation of a secure CA for issuing a certificate is modeled with one rule for each type of observed CAA record:

1. if a DNSSEC-protected CAA record exists (see [DomainOwnerCreatePopRequest]), the CA will accept a CAA issue record with an account URI [CaAcceptSignedCaaIssueRecordWithAccountUri], a CAA HSV record with the secure-dns-record-change validation method [CaAcceptSignedCaaHsvRecordForDnssecRecordChange], or a CAA HSV record with the known-account-specifier validation method [CaAcceptSignedCaaHsvRecordForKnownAccountSpecifier].
2. if an NSEC record shows the non-existence of a secure delegation for the domain (see [DomainOwnerCreatePoaRequest]), the CA issues a certificate without any CAA record since the adversary can block retrieval of the CAA record [CaAcceptPoaWithoutCaaRecord] or it accepts an unsigned CAA record [CaAcceptUnsignedCaaRecord].
3. if an NSEC record shows that the zone is DNSSEC protected but no CAA record exists (see [DomainOwnerCreatePopNoCaaRequest]), the CA will issue a certificate without any CAA record [CaAcceptPopWithoutCaaRecord].

A CA does not issue duplicate certificates, i.e., multiple certificates for the same domain and public key are not allowed [NoDuplicateIdenticalCertIssued].

Additionally, we model a secure but non-participating CA [NonParticipatingCaIgnoreNonCriticalSignedCaaHsvRecordDowngradeToHttpValidation], an insecure CA that does not check if a CSR is self-signed [InsecureCaNoCsrSignatureCheckAcceptSignedCaaRecord], and an insecure CA that does not properly perform DNSSEC checks [InsecureCaNoDnssecAcceptCaaRecord].

#### Certificate Usage in TLS
Once a certificate is issued, the domain owner can use it to sign a TLS transcript during the TLS handshake to protect the integrity of the handshake message [SignTlsTranscript] (note that we simplified the transcript to only contain the queried domain and no other fields).
Similarly, an adversary can attempt to sign a TLS transcript for any domain if they know the TLS private key corresponding to the public key in the certificate [AdversarySignTlsTranscript].

#### Restrictions
The equality restriction allows rules to check the validity of signatures by using the action fact Eq(verify(signature, message, publicKey), true) {Equality}.

We also define a set of restrictions, which are purely there for improving the visualization of proofs, but do not impact the capabilities of an adversary.
E.g., the Tamarin prover may derive an identical DS record multiple times which makes it difficult to see patterns in the proof visualization [NoDuplicateDsRecords,NoDuplicateDnssecDsOrRootValidations,NoDuplicateDnssecLabelValidations,NoDuplicateCertIssueRequests,OnlySingleAccountPerDomainAndOwner,OnlySingleCaaRecordCreatedPerDomainAndOwner,NoDuplicateDnssecValidationNonces,NoDuplicateClosestEnclosers].

### Lemmas
In Tamarin, lemmas are first-order logic formulas using action facts produced by executing the model.
Lemmas can be existential, i.e., specifying that at least one model execution satisfies the lemma, e.g., the legitimate domain owner can request a certificate from the CA, or they can be universal, i.e., specifying that all possible model executions satisfy the lemma, e.g., the CA does not issue a fake certificate for the victim domain in any circumstances.

#### Main Security Lemmas
- SecureRecordChangeIssuance: if a secure CA issues a certificate for a secure domain where the domain owner created a CAA HSV record with the secure-dns-record-change validation method, the accepted account URI is legitimate
- KnownAccountSpecifierIssuance: same as the previous lemma, but for a CAA HSV record with the known-account-specifier (caOwnerID) validation method
- CaaIssueAccountUriIssuance: same as the previous lemma, but for a regular CAA issue record containing an account URI
- NoFakeCertificateIssuance: if a secure CA issues a certificate for a domain where the domain owner specified either an account URI in a CAA issue record or a CAA HSV record, the certificate contains the domain owner's legitimate TLS public key.
- OnlyLegitimateDomainOwnerCanAuthenticate: if a domain owner specifies either an account URI in a CAA issue record or a CAA HSV record, only the legitimate domain owner is able to use a certificate issued by a secure CA, to sign a TLS transcript for their domain.
- OnlyLegitimateKeyHolderCanIssueCertForPublicKey: only the actual holder of a TLS private key can request a certificate for the respective public key, which holds since the CSR is signed by the respective TLS private key.

#### Executability Lemmas
Any of these security properties hold trivially if the model is not executable, e.g., if neither the domain owner nor the adversary can issue a certificate, no fake certificate will ever be issued and thus the first security property holds.
All remaining lemmas that are not helper lemmas prove that (1) both domain owners and adversaries can issue certificates for their domains, (2) adversaries can request fake certificates if DNSSEC keys are compromised, or the domain owners do not enable DNSSEC for their domain or any ancestor domain, or (3) insecure CA implementations allow for fake certificate issuance even for secure domains.

1. Certificate issuance is possible:
   - CanAuthenticateSecureDomainSld
   - CanAuthenticateNoDnssecDomainSld
   - CanAuthenticateNoCaaDomainSld
   - CanAuthenticateAdversaryDomainSld
   - LegitimateUriAcceptedForVictimNoDnssecDomainSld
   - LegitimateUriAcceptedForVictimNoCaaDomainSld
   - CanAuthenticateSecureDomainSldWithDnssecRecordChange
   - AdversaryCanAuthenticateSecureDomainSldWithDnssecRecordChange
   - CanAuthenticateSecureDomainSldWithKnownAccountSpecifier
   - AdversaryCanAuthenticateSecureDomainSldWithKnownAccountSpecifier
   - LegitimateCaaAcceptedForVictimDomain
   - AdversaryCaaAcceptedForAdversaryDomain
2. Adversaries can obtain fake certificates if assumptions are violated:
   - AdversaryUriAcceptedForVictimNoDnssecDomainSld
   - AdversaryUriAcceptedForVictimNoCaaDomainSld
   - AdversaryCanAuthenticateNoDnssecDomainSld
   - AdversaryCanAuthenticateNoCaaDomainSld
   - AdversaryCaaAcceptedForVictimDomainWithKeyReveal
   - AdversaryCanAuthenticateIfDnssecKeyIsRevealed
3. Insecure CA implementations subvert the security guarantees:
   - NonParticipatingCaDomainOwnerCanAuthenticateIfHsvCriticalBitIsNotSet
   - FakeCertificateWithoutCriticalFlag
   - InsecureCaNoDnssecAdversaryCaaAcceptedForVictimDomain


#### Helper Lemmas
Helper lemmas are indicated with the reuse tag to allow them to be used in subsequent lemmas.
The often help detecting infeasible model states early to (sometimes drastically) reduce proof times.

- HasApexDomain: any domain must have an apex domain that points to itself; helps find contradictions due to circular dependencies
- SecureDnssecChainNewLabelHasSecureApex: the zone of a secure non-apex domain must be secure
- SecureChainExtendsToOwnZone: the zone of any secure domain must also be secure
- SecureChainExtendsToParentZone: the parent zone of a secure apex domain must also be secure
- SingleDomainOwnerPerZone: each zone has a single owner, helps to find contradictions if a zone would be owned by the adversary and a legitimate domain owner
- SingleZonePerDomain: apex domain assignment is unique
- NoCyclicZonesParentHeuGeneric: a child domain cannot be the apex of the parent domain
- ValidDnssecKeySelectedByRoot: once the prover arrives at the root zone, any validated public key must be the key selected by the legitimate root zone
- SecureChainOwnedByBenignDomainOwner: a secure domain must be owned by a benign domain owner; helps detect and reject cases early where the domain would have needed to be owned by the domain owner
- DnssecKeyValidatedUsingLabelMustHaveDelegationSignerOrRootAncestor: any key validated for a secure non-apex domain must originate in an earlier key validation for an ancestor domain; facilitates finding temporal contradictions.
- ValidPublicKeyIsNotKnownToAdversaryApexOnly: the private key associated with a public key validated for a secure apex domain is not known to the adversary
- ValidPublicKeyIsNotKnownToAdversary: same as the previous lemma but it holds for any secure domain, not only for apex domains

### Message Format
We use the following naming convention: angle brackets indicate fixed size tuples, square brackets indicate fixed size bitmaps, and values in single quotes are fixed string constants.

#### NSEC
For NSEC records, we are only interested in the proof of absence/presence of the CAA record, hence we do not model other record types for NSEC.

- type bitmap order: [ caa ]
- CAA record PoP value = < 'nsecpop', domain, [ '1' ] >
- CAA record PoA value = < 'nsecpop', domain, [ '0' ] >
- Domain PoA value = < 'nsecpoa', domain >
- signed NSEC record = < value, sign(nsec, dnssecPrivateKey) >

#### CAA
- CAA issue record: < 'caa', domain, critical, 'issue', caIdentifier, accountUri >
- CAA HSV record: < 'caa', domain, critical, 'hsv', caIdentifier, validationMethods, caOwnerId, globalOwnerId >
  - validation methods bitmap order: [ dnssec-record-change, http-validation-over-tls, known-account-specifier (used in combination with caOwnerId), private-key-control (used in combination with globalOwnerId), http (insecure), no-dnssec-record-change (insecure) ]
- signedCaa = < caa, sign(caa, dnssecPrivateKey) >

Note that for simplicity, we use a single bitmap covering both secure and insecure validation methods but the CAA HSV record disallows the use of insecure validation methods.

#### CSR
- value = < 'csr', domain, tlsPublicKey >
- csr = < value, sign(csr, tlsPrivateKey) >

#### Certificate
- value = < 'cert', domain, publicKey, caIdentifier >
- cert = < cert, sign(cert, caPrivateKey) >

#### Signed TLS Transcript
- value = < 'transcript', domain >
- transcript = < value, sign(value, tlsPrivateKey) >
