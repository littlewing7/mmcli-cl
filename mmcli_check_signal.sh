#!/usr/bin/env bash
#===============================================================================
#
#          FILE: mmcli_check_signal.sh
#
#         USAGE: ./mmcli_check_signal.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Massimo Manzato (mma), massimo.manzato <@> gmail dot com
#  ORGANIZATION: 
#       CREATED: 04/14/26 10:29:19
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

# --- COLOR CONFIGURATION ---
# Terminal ANSI escape codes
C_RESET="\033[0m"
C_EXCELLENT="\033[32m" # Green
C_GOOD="\033[92m"      # Light Green
C_FAIR="\033[33m"      # Yellow
C_POOR="\033[31m"      # Red
C_TITLE="\033[1m\033[36m" # Bold Cyan

awk -v r="$C_RESET" -v exc="$C_EXCELLENT" -v g="$C_GOOD" -v f="$C_FAIR" -v p="$C_POOR" -v t="$C_TITLE" '
BEGIN {
    FS = ":"
    print t "--- SIGNAL QUALITY ANALYSIS ---" r
    printf "%-10s | %-8s | %-15s\n", "METRIC", "VALUE", "STATUS"
    print "--------------------------------------------"
}

# Function to map numeric values to qualitative status
function evaluate_signal(val, type) {
    # RSRP: Reference Signal Received Power (dBm)
    if (type ~ /rsrp/) {
        if (val >= -80)  return exc "Excellent" r
        if (val >= -90)  return g   "Good" r
        if (val >= -105) return f   "Fair" r
        return p "Poor (Weak)" r
    }
    # RSRQ: Reference Signal Received Quality (dB)
    if (type ~ /rsrq/) {
        if (val >= -10) return exc "Excellent" r
        if (val >= -15) return f   "Fair" r
        return p "Poor" r
    }
    # SNR: Signal-to-Noise Ratio (dB)
    if (type ~ /snr/) {
        if (val >= 20) return exc "Excellent" r
        if (val >= 13) return g   "Good" r
        if (val >= 0)  return f   "Fair" r
        return p "Poor" r
    }
}

# Process lines containing LTE or 5G signal data
/modem.signal.(lte|5g).(rsrp|rsrq|snr)/ {
    # Ignore lines with no data (--)
    if ($2 ~ /--/) next
    
    # Extract tech (lte/5g) and metric (rsrp/rsrq/snr) from the key
    split($1, parts, ".")
    tech = toupper(parts[3])
    metric = parts[4]
    val = $2 + 0 # Convert to numeric
    
    printf "%-10s | %-8s | %s\n", tech " " toupper(metric), $2, evaluate_signal(val, metric)
    
    # Store RSRP and SNR for final summary (using LTE as priority)
    if (metric == "rsrp") current_rsrp = val
    if (metric == "snr") current_snr = val
}

END {
    print "--------------------------------------------"
    # Final warning based on standard thresholds
    if (current_rsrp != 0 && (current_rsrp < -105 || current_snr < 5)) {
        print p "ADVICE: Critical signal levels detected. Consider re-positioning." r
    } else if (current_rsrp != 0) {
        print g "ADVICE: Connection is stable." r
    }
}
'
