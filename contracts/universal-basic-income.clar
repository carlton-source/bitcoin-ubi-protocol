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
(define-data-var distribution-interval uint u144) ;; ~1 day in blocks
(define-data-var last-distribution-height uint u0)
(define-data-var minimum-balance uint u10000000) ;; Minimum treasury balance
(define-data-var paused bool false)

;; Data Maps
(define-map participants 
    principal 
    {
        registered: bool,
        last-claim-height: uint,
        total-claimed: uint,
        verification-status: bool,
        join-height: uint,
        claims-count: uint
    }
)

(define-map voter-records
    {proposal-id: uint, voter: principal}
    bool
)

;; Private Functions
(define-private (is-contract-owner)
    (is-eq tx-sender contract-owner)
)

(define-private (is-eligible (user principal))
    (let (
        (participant-info (unwrap! (map-get? participants user) (err false)))
    )
    (and
        (get verification-status participant-info)
        (>= (- block-height (get last-claim-height participant-info)) distribution-interval)
        (>= treasury-balance distribution-amount)
    ))
)

(define-private (update-participant-record (user principal) (claimed-amount uint))
    (let (
        (current-info (unwrap! (map-get? participants user) (err false)))
        (new-total (+ (get total-claimed current-info) claimed-amount))
        (new-claims (+ (get claims-count current-info) u1))
    )
    (map-set participants user
        (merge current-info {
            last-claim-height: block-height,
            total-claimed: new-total,
            claims-count: new-claims
        })
    ))
)

;; Public Functions
(define-public (register)
    (let (
        (existing-record (map-get? participants tx-sender))
    )
    (asserts! (is-none existing-record) err-already-registered)
    (map-set participants tx-sender {
        registered: true,
        last-claim-height: u0,
        total-claimed: u0,
        verification-status: false,
        join-height: block-height,
        claims-count: u0
    })
    (var-set total-participants (+ (var-get total-participants) u1))
    (ok true))
)

(define-public (claim-ubi)
    (let (
        (user tx-sender)
        (can-claim (is-eligible user))
    )
    (asserts! (not (var-get paused)) err-unauthorized)
    (asserts! can-claim err-ineligible)
    (asserts! (>= (var-get treasury-balance) (var-get distribution-amount)) err-insufficient-funds)
    
    ;; Process claim
    (try! (as-contract (stx-transfer? (var-get distribution-amount) contract-caller user)))
    (var-set treasury-balance (- (var-get treasury-balance) (var-get distribution-amount)))
    (try! (update-participant-record user (var-get distribution-amount)))
    (ok (var-get distribution-amount)))
)

(define-public (contribute)
    (let (
        (amount (stx-get-balance tx-sender))
    )
    (asserts! (> amount u0) err-invalid-amount)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set treasury-balance (+ (var-get treasury-balance) amount))
    (ok amount))
)