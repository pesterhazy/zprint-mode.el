(defun zprint ()
  (interactive)
  (save-excursion
    (let ((b (if mark-active (min (point) (mark)) (point-min)))
          (e (if mark-active (max (point) (mark)) (point-max))))
      (call-process-region b
                           e
                           "bash"
                           t
                           t
                           nil
                           "-c"
                           "set -euo pipefail;our_temp_dir=$(mktemp -d 2>/dev/null||mktemp -d -t \"our_temp_dir\");function cleanup_temp_dir(){ rm -rf \"$our_temp_dir\";}&&trap \"cleanup_temp_dir\" EXIT;url=\"https://github.com/kkinnear/zprint/releases/download/0.4.11/zprintm-0.4.11\";dir=\"$HOME/.zprint-cache\";expected_sha=\"dfe2eb7446253c23d91487cf962e9e6ecbbe747f7915caa815ddadcba76b8a93\";if ! [[ -f \"$dir/${expected_sha}\" ]];then mkdir -p \"$dir\";curl -SL -o \"$our_temp_dir/zprint\" \"$url\";actual_sha=\"$(python -c \"import sys,hashlib; m=hashlib.sha256(); f=open(sys.argv[1]) if len(sys.argv)>1 else sys.stdin; m.update(f.read()); print(m.hexdigest())\" \"$our_temp_dir/zprint\")\";if [[ \"$actual_sha\" != \"$expected_sha\" ]];then printf \"Sha mismatch. Expected=%s Actual=%s\\n\" \"$expected_sha\" \"$actual_sha\";exit 1;fi;chmod +x \"$our_temp_dir/zprint\";mv \"$our_temp_dir/zprint\" \"$dir/${expected_sha}\";fi;cleanup_temp_dir;exec \"$dir/${expected_sha}\" \"$@\""
                           ))))
