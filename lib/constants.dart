import 'package:flutter/material.dart';

const BASE_URL = "localnano.de/";
const API_BASE_URL = "api." + BASE_URL;
const WWW_BASE_URL = "www." + BASE_URL;
const HTTPS_PREFIX = "https://";
const API_URL = HTTPS_PREFIX + API_BASE_URL;
const WWW_URL = HTTPS_PREFIX + WWW_BASE_URL;

const NEW_KEY_ADVICE =
    "Below, you will see a randomly generated key. This key is the " +
        "spending key to your account, which currently holds 0 " +
        "balance. If you keep this key a secret, then you and only " +
        "you, will be able to spend the funds that belong to this " +
        "account. If you lose this secret key, then all funds " +
        "delegated to this account will be lost. It is recommended " +
        "that you at least take a screenshot of this secret key, " +
        "or copy it and paste it into a note. However, for the best " +
        "security, it is recommended to write this key down on " +
        "several pieces on paper, and keep in a safe & " +
        "secret place.";

const double BTN_FONT_SIZE = 24;
const BTN_COLOR = Colors.blueAccent;