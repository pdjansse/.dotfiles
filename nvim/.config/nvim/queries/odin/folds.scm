;; 1. Fold parameters independently.
;; We mathematically offset the end line (-1) so it cannot physically 
;; collide with the block fold that starts on the exact same line.
((parameters) @fold
 (#offset! @fold 0 0 -1 0))

;; 2. Fold the body block normally
(block) @fold

;; 3. Restore standard language folds
(struct_type) @fold
(enum_type) @fold
(union_type) @fold
(comment) @fold
