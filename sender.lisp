#!/usr/bin/env sbcl --script
;;;
;;; PCERR/1.0 reference sender (Common Lisp implementation)
;;;
;;; Usage:
;;;     sbcl --script sender.lisp --pce pce.demo.illumio.com --rebooter jeff.schmitz
;;;

(defconstant +magic+ #x4A454646) ; "JEFF"
(defconstant +version+ 1)
(defconstant +port+ 8420)

(defconstant +flag-please+ (ash 1 0))
(defconstant +flag-thanks+ (ash 1 1))
(defconstant +flag-beer+ (ash 1 2))
(defconstant +flag-urgent+ (ash 1 3))
(defconstant +flag-sorry+ (ash 1 4))
(defconstant +flag-reciprocate+ (ash 1 5))

(defun build-packet (pce-fqdn &key (urgency 5) (coffee-level 7) (guilt-trip ""))
  "Construct a PCERR/1.0 packet. The B and P flags are non-negotiable."
  (let* ((flags (logior +flag-please+ +flag-thanks+ +flag-beer+
                        +flag-sorry+ +flag-reciprocate+))
         (header (make-array 8 :element-type '(unsigned-byte 8)))
         (payload-str (concatenate 'string pce-fqdn (string #\Null) guilt-trip))
         (payload (babel:string-to-octets payload-str :encoding :utf-8)))

    ;; Pack header: magic (4 bytes), version (1), urgency (1), coffee-level (1), flags (1)
    ;; Network byte order (big-endian)
    (setf (aref header 0) (ldb (byte 8 24) +magic+))
    (setf (aref header 1) (ldb (byte 8 16) +magic+))
    (setf (aref header 2) (ldb (byte 8 8) +magic+))
    (setf (aref header 3) (ldb (byte 8 0) +magic+))
    (setf (aref header 4) +version+)
    (setf (aref header 5) urgency)
    (setf (aref header 6) coffee-level)
    (setf (aref header 7) flags)

    (concatenate '(vector (unsigned-byte 8)) header payload)))

(defun send-packet (packet rebooter)
  "Transmit packet over the colleague-bus. Implementation left as exercise."
  (format t "[PCERR] Dispatching ~D bytes to ~A on TCP/~D~%"
          (length packet) rebooter +port+)
  (format t "[PCERR] Awaiting SYN-ACK (typical RTT: 5-45 minutes)~%"))

(defun parse-args (args)
  "Parse command-line arguments."
  (let ((pce nil)
        (rebooter nil)
        (guilt-trip ""))
    (loop for (key val) on args by #'cddr
          do (cond
               ((string= key "--pce") (setf pce val))
               ((string= key "--rebooter") (setf rebooter val))
               ((string= key "--guilt-trip") (setf guilt-trip val))))
    (unless (and pce rebooter)
      (format *error-output* "Usage: sender.lisp --pce <fqdn> --rebooter <username> [--guilt-trip <text>]~%")
      (sb-ext:exit :code 1))
    (values pce rebooter guilt-trip)))

(defun main ()
  "Main entry point."
  (multiple-value-bind (pce rebooter guilt-trip)
      (parse-args (rest sb-ext:*posix-argv*))
    (let ((packet (build-packet pce :guilt-trip guilt-trip)))
      (send-packet packet rebooter))))

;; Only run main if executed as script
(when (member :sbcl *features*)
  (handler-case
      (main)
    (error (e)
      (format *error-output* "Error: ~A~%" e)
      (sb-ext:exit :code 1))))
