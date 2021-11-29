## Make TLS Cert
```shell
git clone https://github.com/tkaburagi/tf-tls-cert
cd tf-tls-cert
```

Change `vars.tf`. Replace `Users/kabu/hashicorp/terraform/tf-tls-cert` to your path.

```hcl
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ca_common_name" {
  default = "vault.acme.io cert"
}

variable "ca_public_key_file_path" {
  default = "/Users/kabu/hashicorp/terraform/tf-tls-cert/vaultca.crt.pem"
}

variable "common_name" {
  default = "acme.io cert"
}

variable "dns_names" {
  default = ["*.vault-internal"]
}

variable "ip_addresses" {
  default = ["127.0.0.1"]
}

variable "organization_name" {
  default = "HashiCorp Inc."
}

variable "private_key_file_path" {
  default = "/Users/kabu/hashicorp/terraform/tf-tls-cert/vault.key.pem"
}

variable "public_key_file_path" {
  default = "/Users/kabu/hashicorp/terraform/tf-tls-cert/vault.crt.pem"
}

variable "validity_period_hours" {
  default = "765"
}

variable "owner" {
  default = "kabu"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ca_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the CA certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = list(string)

  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

variable "allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = list(string)

  default = [
    "key_encipherment",
    "digital_signature",
  ]
}

variable "permissions" {
  description = "The Unix file permission to assign to the cert files (e.g. 0600)."
  default     = "0600"
}

variable "private_key_algorithm" {
  description = "The name of the algorithm to use for private keys. Must be one of: RSA or ECDSA."
  default     = "RSA"
}

variable "private_key_ecdsa_curve" {
  description = "The name of the elliptic curve to use. Should only be used if var.private_key_algorithm is ECDSA. Must be one of P224, P256, P384 or P521."
  default     = "P256"
}

variable "private_key_rsa_bits" {
  description = "The size of the generated RSA key in bits. Should only be used if var.private_key_algorithm is RSA."
  default     = "2048"
}
```

## Set the Cert to K8s
Replace `Users/kabu/hashicorp/terraform/tf-tls-cert` to your path.
```shell
kubectl create secret generic vault-server-tls \
        --namespace default \
        --from-file=vault.key=/Users/kabu/hashicorp/terraform/tf-tls-cert/vault.key.pem \
        --from-file=vault.crt=/Users/kabu/hashicorp/terraform/tf-tls-cert/vault.crt.pem \
        --from-file=vault.ca=/Users/kabu/hashicorp/terraform/tf-tls-cert/vaultca.crt.pem
```

## Install 
```shell
helm install vault hashicorp/vault -f server-3.yaml 
```

## Init
```shell
kubectl exec -ti vault-0 -- /bin/sh
/ $ export VAULT_ADDR=https://127.0.0.1:8200
/ $ vault operator init
Recovery Key 1: xx
Recovery Key 2: xx
Recovery Key 3: xx
Recovery Key 4: xx
Recovery Key 5: xx

Initial Root Token: xx

Success! Vault is initialized

Recovery key initialized with 5 key shares and a key threshold of 3. Please
securely distribute the key shares printed above.
```

Confirm all pods are running and joined the same cluster.