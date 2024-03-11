#!/bin/bash

# Bash Script to Analyze Network Traffic

# Input: Path to the Wireshark pcap file
pcap_file= # capture input from terminal.

# Function to extract information from the pcap file
analyze_traffic() {
    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    # extract IP addresses, and generate summary statistics.

    # Output analysis summary
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    echo "1. Total Packets: [your_total_packets]"
    echo "2. Protocols:"
    echo "   - HTTP: [your_http_packets] packets"
    echo "   - HTTPS/TLS: [your_https_packets] packets"
    echo ""
    echo "3. Top 5 Source IP Addresses:"
    # Provide the top source IP addresses
    echo "[your_top_source_ips]"
    echo ""
    echo "4. Top 5 Destination IP Addresses:"
    # Provide the top destination IP addresses
    echo "[your_top_dest_ips]"
    echo ""
    echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic
