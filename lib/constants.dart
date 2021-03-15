import 'package:flutter/material.dart';

const BASE_URL = 'https://www.localnano.de/'; // server url
const API_BASE_URL = BASE_URL + 'api/'; // api endpoint

const NEW_KEY_ADVICE = // advice per the NewAccount route
    "Below, you will see a randomly generated key. This key is the " +
        "spending key to your account, which currently holds 0 " +
        "balance. If you keep this key a secret, then you and only " +
        "you, will be able to spend the funds that belong to this " +
        "account. If you lose this secret key, then all funds " +
        "delegated to this account will be lost. It is recommended " +
        "that you at least take a screenshot of this secret key, " +
        "or copy it and paste it into a note. However, for the best " +
        "security, it is recommended to write this key down on " +
        "several pieces of paper, and keep them in a safe & " +
        "secret place.";
const IMPORT_ADVICE = // advice per the ImportAccount route
    "Warning! Importing, or attempting to use, a compromised private " +
        "key on LocalNano may result in the loss of all funds! You alone " +
        "are responsible for your funds. Keep your keys secret.";

const double BTN_FONT_SIZE =
    24; // default value for navigation TextButton height
const double BACK_BTN_FONT_SIZE =
    18; // default value for back navigation TextButton height
const BTN_COLOR = Colors.blueAccent; // default color for navigation buttons

const PREFS_PRIVATE = 'private'; // key:v for 64 character hex private key
const PREFS_PUBLIC = 'public'; // key:v for nano_... address
