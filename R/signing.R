#' PGP Signatures
#'
#' Utilities to create and verify PGP signatures.
#'
#' @export
#' @rdname gpg_sign
#' @name gpg_sign
#' @aliases gpg
#' @family gpg
#' @useDynLib gpg R_gpgme_verify
#' @param signature path or raw vector for the gpg signature (contains the \code{PGP SIGNATURE} block)
#' @param error raise an error if verification fails because you do not have the
#' signer public key in your keyring.
#' @examples # This requires you have the Debian master key in your keyring
#' msg <- tempfile()
#' sig <- tempfile()
#' download.file("http://http.us.debian.org/debian/dists/jessie/Release", msg)
#' download.file("http://http.us.debian.org/debian/dists/jessie/Release.gpg", sig)
#' gpg_verify(sig, msg, error = FALSE)
gpg_verify <- function(signature, data = NULL, error = TRUE){
  sig <- file_or_raw(signature)
  if(!is.null(data))
    data <- file_or_raw(data)
  out <- .Call(R_gpgme_verify, sig, data)
  out <- data.frame(out, stringsAsFactors = FALSE)
  if(isTRUE(error) && !any(out$success)){
    fp_failed <- out$fingerprint[!(out$success)]
    stop("Verification failed. None of the pubkeys not found in keyring: ", paste(fp_failed, collapse = ", "), call. = FALSE)
  } else {
    out
  }
}

#' @useDynLib gpg R_gpg_sign
#' @export
#' @param data path or raw vector with data to sign or verify. In `gpg_verify` this
#' should be `NULL` if `signature` is not detached (i.e. `clear` or `normal` signature)
#' @param signer (optional) vector with key ID's to use for signing. If `NULL`, GPG tries
#' the user default private key.
#' @param mode use `normal` to create a full OpenPGP message containing both data and
#' signature or `clear` append the signature to the clear-text data (for email messages).
#' Default `detach` only returns the signature itself.
#' @rdname gpg_sign
gpg_sign <- function(data, signer = NULL, mode = c("detach", "normal", "clear")){
  mode <- match.arg(mode)
  if(is.character(data)){
    stopifnot(file.exists(data))
    data <- readBin(data, raw(), file.info(data)$size)
  }
  if(is.null(signer)){
    seckeys <- gpg_list_keys(secret = TRUE)
    if(!nrow(seckeys))
      warning("No suitable private keys founds in keyring", immediate. = TRUE, call. = FALSE)
  }
  stopifnot(is.raw(data))
  .Call(R_gpg_sign, data, signer, mode)
}
