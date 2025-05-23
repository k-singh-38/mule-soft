package hl7.processor;

import dwl.core.*;

fun process_ack_message(message_string: String): String {
  var input_map = {};
  var output_map = {};
  try {
    input_map = parse_hl7_message(message_string);
    output_map = {};
    var skip = false;
    if (input_map['MSA'] != null && input_map['MSA'].size() > 0) {
      if (input_map['MSA'].size() > 1) {
        log('More than one MSA segment found.');
      }
      var msa_text_message = input_map['MSA'][0]['MSA-3-text_message'];
      if (msa_text_message contains 'ZZZ') {
        skip = true;
        log('Message contains "ZZZ" and will be skipped.');
      } else {
        log('Message will be processed.');
      }
    } else {
      log('No MSA segments found or MSA segments are empty.');
      skip = false;
    }
    if (!skip) {
      if (input_map['MSH'] != null) {
        output_map['MSH'] = input_map['MSH'];
      } else {
        log('MSH segment is missing in input_map.');
        return '';
      }
      output_map['MSA'] = input_map['MSA'];
    } else {
      output_map = {};
    }
    var output_string = write(output_map, 'application/json');
    input_map = {};
    output_map = {};
    return output_string;
  } catch (error) {
    return '';
  }
}