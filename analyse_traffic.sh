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

# Function to get the most frequent addresses
get_top_5_addresses() {
    # Declare an associative array to hold the count of each address
    declare -A address_counts

    # Loop through the array passed to the function and count each address
    for address in "${@}"; do
        ((address_counts[$address]++))
    done

    # Convert associative array to a list of "count address" and sort them
    for address in "${!address_counts[@]}"; do
        echo "${address_counts[$address]} $address"
    done | sort -rn | head -5 | awk '{print $2": "$1" packets"}'
}

# Function to extract information from the pcap file
analyze_traffic() {
    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    # extract IP addresses, and generate summary statistics.

    # Making sure that tshark package is installed
    if [[ $(dpkg -s tshark | grep Status) != *install* ]]; then
        echo "Installing tshark package ..."
        sudo apt install tshark
    fi
    
    # Retrieving pcap file
    data=$(tshark -r "$pcap_file")

    declare -a data_array
    declare -a source_addresses
    declare -a destination_addresses
    declare -i http_counter=0
    declare -i tls_counter=0
    while IFS='' read -r packet || [[ -n "$packet" ]]; do
        # Split the line into an array of items
        IFS=' ' read -ra packet_array <<< "$packet"
            if [[ "${packet_array[5]}" == *"HTTP"* ]]; then
                http_counter+=1
            elif [[ "${packet_array[5]}" == *"TLS"* ]]; then
                tls_counter+=1
            fi
            source_addresses+=("${packet_array[2]}")
            destination_addresses+=("${packet_array[4]}")
            data_array+=("$packet")
    done <<< "$data"

    # Output analysis summary
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    read -r -a last_packet_array <<< "${data_array[-1]}"
    echo "1. Total Packets: ${last_packet_array[0]}"
    echo "2. Protocols:"
    echo "   - HTTP: ${http_counter} packets"
    echo "   - HTTPS/TLS: ${tls_counter} packets"
    echo ""
    echo "3. Top 5 Source IP Addresses:"
    # Provide the top source IP addresses
    get_top_5_addresses "${source_addresses[@]}"
    echo ""
    echo "4. Top 5 Destination IP Addresses:"
    # Provide the top destination IP addresses
    get_top_5_addresses "${destination_addresses[@]}"
    echo ""
    echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic
