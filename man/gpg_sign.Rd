% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signing.R
\name{gpg_verify}
\alias{gpg}
\alias{gpg_sign}
\alias{gpg_verify}
\title{PGP Signatures}
\usage{
gpg_verify(file, signature)

gpg_sign(file, id)
}
\arguments{
\item{file}{file-path or raw vector with data to sign or verify}

\item{signature}{path or raw vector for the gpg signature file (contains the \code{PGP SIGNATURE} block)}

\item{id}{which private key to use for signing}
}
\description{
Utilities to create and verify PGP signatures.
}
\examples{
# This requires you have the Debian master key in your keyring
# See https://lists.debian.org/debian-devel-announce/2014/11/msg00017.html
# gpg --keyserver pgp.mit.edu --recv 0x7638d0442b90d010
msg <- tempfile()
sig <- tempfile()
download.file("http://http.us.debian.org/debian/dists/jessie/Release", msg)
download.file("http://http.us.debian.org/debian/dists/jessie/Release.gpg", sig)
gpg_verify(msg, sig)
}
\seealso{
Other gpg: \code{\link{gpg_search}}
}
