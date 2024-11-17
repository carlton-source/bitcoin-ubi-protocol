;; title: Bitcoin-backed Universal Basic Income Protocol
;; summary: A smart contract for managing a universal basic income (UBI) system backed by Bitcoin.
;; description: This contract allows participants to register, verify their status, and claim UBI distributions. It includes governance functions for submitting and voting on proposals, as well as emergency functions to pause and unpause the contract. The contract ensures that only eligible participants can claim UBI and maintains a record of all participants and their claim history.

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-registered (err u102))
(define-constant err-ineligible (err u103))
(define-constant err-cooldown-active (err u104))
(define-constant err-insufficient-funds (err u105))
(define-constant err-invalid-amount (err u106))
(define-constant err-unauthorized (err u107))

;; Data Variables
(define-data-var treasury-balance uint u0)
(define-data-var total-participants uint u0)
(define-data-var distribution-amount uint u1000000) ;; 1 STX = 1000000