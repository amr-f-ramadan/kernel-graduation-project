#!/bin/bash

# Bash Script to Analyze Network Traffic

# Input: Path to the Wireshark pcap file

if [ $1 ]; then
    if [ -f "$1" ]; then
        pcap_file=$1 # capture input from terminal.
    else
        echo "pcap file not found"
        exit 1
    fi
else
     echo "No directory provided"
     exit 2
fi

# Function to extract information from the pcap file
analyze_traffic() {
    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    # extract IP addresses, and generate summary statistics.

    if [[ $(dpkg -s tshark | grep Status) != *install* ]]; then
        echo "Installing tshark package ..."
        sudo apt install tshark
    fi
    
    data=$(tshark -r "$pcap_file")

    declare -a data_array
    declare -i http_counter=0
    declare -i tls_counter=0
    top_source_addresses=""
    top_destination_addresses=""
    while IFS='' read -r packet || [[ -n "$packet" ]]; do
        # Split the line into an array of items
        IFS=' ' read -ra packet_array <<< "$packet"
            if [ "${packet_array[0]}" -le 5 ]; then
                top_source_addresses+="${packet_array[2]}"$'\n'
                top_destination_addresses+="${packet_array[4]}"$'\n'             
            fi
            if [[ "${packet_array[5]}" == *"HTTP"* ]]; then
                http_counter+=1
            elif [[ "${packet_array[5]}" == *"TLS"* ]]; then
                tls_counter+=1
            fi
            data_array+=("$packet")
    done <<< "$data"
    read -r -a last_packet_array <<< "${data_array[-1]}"

    # Output analysis summary
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    echo "1. Total Packets: ${last_packet_array[0]}"
    echo "2. Protocols:"
    echo "   - HTTP: ${http_counter} packets"
    echo "   - HTTPS/TLS: ${tls_counter} packets"
    echo ""
    echo "3. Top 5 Source IP Addresses:"
    # Provide the top source IP addresses
    echo "${top_source_addresses}"
    echo ""
    echo "4. Top 5 Destination IP Addresses:"
    # Provide the top destination IP addresses
    echo "${top_destination_addresses}"
    echo ""
    echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic
