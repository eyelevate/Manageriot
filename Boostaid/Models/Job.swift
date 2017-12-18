//
//  Job.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/27/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation

class Job {
    static let states : Array<String> = [
        "Select A State",
        "ALABAMA",
        "ALASKA",
        "AMERICAN SAMOA",
        "ARIZONA",
        "ARKANSAS",
        "CALIFORNIA",
        "COLORADO",
        "CONNECTICUT",
        "DELAWARE",
        "DISTRICT OF COLUMBIA",
        "FEDERATED STATES OF MICRONESIA",
        "FLORIDA",
        "GEORGIA",
        "GUAM GU",
        "HAWAII",
        "IDAHO",
        "ILLINOIS",
        "INDIANA",
        "IOWA",
        "KANSAS",
        "KENTUCKY",
        "LOUISIANA",
        "MAINE",
        "MARSHALL ISLANDS",
        "MARYLAND",
        "MASSACHUSETTS",
        "MICHIGAN",
        "MINNESOTA",
        "MISSISSIPPI",
        "MISSOURI",
        "MONTANA",
        "NEBRASKA",
        "NEVADA",
        "NEW HAMPSHIRE",
        "NEW JERSEY",
        "NEW MEXICO",
        "NEW YORK",
        "NORTH CAROLINA",
        "NORTH DAKOTA",
        "NORTHERN MARIANA ISLANDS",
        "OHIO",
        "OKLAHOMA",
        "OREGON",
        "PALAU",
        "PENNSYLVANIA",
        "PUERTO RICO",
        "RHODE ISLAND",
        "SOUTH CAROLINA",
        "SOUTH DAKOTA",
        "TENNESSEE",
        "TEXAS",
        "UTAH",
        "VERMONT",
        "VIRGIN ISLANDS",
        "VIRGINIA",
        "WASHINGTON",
        "WEST VIRGINIA",
        "WISCONSIN",
        "WYOMING",
        "ARMED FORCES AFRICA | CANADA | EUROPE | MIDDLE EAST",
        "ARMED FORCES AMERICA (EXCEPT CANADA)",
        "ARMED FORCES PACIFIC"
    ]
    
    static let countries: Array<String> = [
        "UNITED STATES",
        "AFGHANISTAN",
        "ALBANIA",
        "ALGERIA",
        "AMERICAN SAMOA",
        "ANDORRA",
        "ANGOLA",
        "ANGUILLA",
        "ANTARCTICA",
        "ANTIGUA AND BARBUDA",
        "ARGENTINA",
        "ARMENIA",
        "ARUBA",
        "AUSTRALIA",
        "AUSTRIA",
        "AZERBAIJAN",
        "BAHAMAS",
        "BAHRAIN",
        "BANGLADESH",
        "BARBADOS",
        "BELARUS",
        "BELGIUM",
        "BELIZE",
        "BENIN",
        "BERMUDA",
        "BHUTAN",
        "BOLIVIA",
        "BOSNIA AND HERZEGOVINA",
        "BOTSWANA",
        "BOUVET ISLAND",
        "BRAZIL",
        "BRITISH INDIAN OCEAN TERRITORY",
        "BRUNEI DARUSSALAM",
        "BULGARIA",
        "BURKINA FASO",
        "BURUNDI",
        "CAMBODIA",
        "CAMEROON",
        "CANADA",
        "CAPE VERDE",
        "CAYMAN ISLANDS",
        "CENTRAL AFRICAN REPUBLIC",
        "CHAD",
        "CHILE",
        "CHINA",
        "CHRISTMAS ISLAND",
        "COCOS (KEELING) ISLANDS",
        "COLOMBIA",
        "COMOROS",
        "CONGO",
        "CONGO, THE DEMOCRATIC REPUBLIC OF THE",
        "COOK ISLANDS",
        "COSTA RICA",
        "COTE D IVOIRE",
        "CROATIA",
        "CUBA",
        "CYPRUS",
        "CZECH REPUBLIC",
        "DENMARK",
        "DJIBOUTI",
        "DOMINICA",
        "DOMINICAN REPUBLIC",
        "EAST TIMOR",
        "ECUADOR",
        "EGYPT",
        "EL SALVADOR",
        "EQUATORIAL GUINEA",
        "ERITREA",
        "ESTONIA",
        "ETHIOPIA",
        "FALKLAND ISLANDS (MALVINAS)",
        "FAROE ISLANDS",
        "FIJI",
        "FINLAND",
        "FRANCE",
        "FRENCH GUIANA",
        "FRENCH POLYNESIA",
        "FRENCH SOUTHERN TERRITORIES",
        "GABON",
        "GAMBIA",
        "GEORGIA",
        "GERMANY",
        "GHANA",
        "GIBRALTAR",
        "GREECE",
        "GREENLAND",
        "GRENADA",
        "GUADELOUPE",
        "GUAM",
        "GUATEMALA",
        "GUINEA",
        "GUINEA-BISSAU",
        "GUYANA",
        "HAITI",
        "HEARD ISLAND AND MCDONALD ISLANDS",
        "HOLY SEE (VATICAN CITY STATE)",
        "HONDURAS",
        "HONG KONG",
        "HUNGARY",
        "ICELAND",
        "INDIA",
        "INDONESIA",
        "IRAN, ISLAMIC REPUBLIC OF",
        "IRAQ",
        "IRELAND",
        "ISRAEL",
        "ITALY",
        "JAMAICA",
        "JAPAN",
        "JORDAN",
        "KAZAKSTAN",
        "KENYA",
        "KIRIBATI",
        "KOREA DEMOCRATIC PEOPLES REPUBLIC OF",
        "KOREA REPUBLIC OF",
        "KUWAIT",
        "KYRGYZSTAN",
        "LAO PEOPLES DEMOCRATIC REPUBLIC",
        "LATVIA",
        "LEBANON",
        "LESOTHO",
        "LIBERIA",
        "LIBYAN ARAB JAMAHIRIYA",
        "LIECHTENSTEIN",
        "LITHUANIA",
        "LUXEMBOURG",
        "MACAU",
        "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF",
        "MADAGASCAR",
        "MALAWI",
        "MALAYSIA",
        "MALDIVES",
        "MALI",
        "MALTA",
        "MARSHALL ISLANDS",
        "MARTINIQUE",
        "MAURITANIA",
        "MAURITIUS",
        "MAYOTTE",
        "MEXICO",
        "MICRONESIA, FEDERATED STATES OF",
        "MOLDOVA, REPUBLIC OF",
        "MONACO",
        "MONGOLIA",
        "MONTSERRAT",
        "MOROCCO",
        "MOZAMBIQUE",
        "MYANMAR",
        "NAMIBIA",
        "NAURU",
        "NEPAL",
        "NETHERLANDS",
        "NETHERLANDS ANTILLES",
        "NEW CALEDONIA",
        "NEW ZEALAND",
        "NICARAGUA",
        "NIGER",
        "NIGERIA",
        "NIUE",
        "NORFOLK ISLAND",
        "NORTHERN MARIANA ISLANDS",
        "NORWAY",
        "OMAN",
        "PAKISTAN",
        "PALAU",
        "PALESTINIAN TERRITORY, OCCUPIED",
        "PANAMA",
        "PAPUA NEW GUINEA",
        "PARAGUAY",
        "PERU",
        "PHILIPPINES",
        "PITCAIRN",
        "POLAND",
        "PORTUGAL",
        "PUERTO RICO",
        "QATAR",
        "REUNION",
        "ROMANIA",
        "RUSSIAN FEDERATION",
        "RWANDA",
        "SAINT HELENA",
        "SAINT KITTS AND NEVIS",
        "SAINT LUCIA",
        "SAINT PIERRE AND MIQUELON",
        "SAINT VINCENT AND THE GRENADINES",
        "SAMOA",
        "SAN MARINO",
        "SAO TOME AND PRINCIPE",
        "SAUDI ARABIA",
        "SENEGAL",
        "SEYCHELLES",
        "SIERRA LEONE",
        "SINGAPORE",
        "SLOVAKIA",
        "SLOVENIA",
        "SOLOMON ISLANDS",
        "SOMALIA",
        "SOUTH AFRICA",
        "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS",
        "SPAIN",
        "SRI LANKA",
        "SUDAN",
        "SURINAME",
        "SVALBARD AND JAN MAYEN",
        "SWAZILAND",
        "SWEDEN",
        "SWITZERLAND",
        "SYRIAN ARAB REPUBLIC",
        "TAIWAN, PROVINCE OF CHINA",
        "TAJIKISTAN",
        "TANZANIA, UNITED REPUBLIC OF",
        "THAILAND",
        "TOGO",
        "TOKELAU",
        "TONGA",
        "TRINIDAD AND TOBAGO",
        "TUNISIA",
        "TURKEY",
        "TURKMENISTAN",
        "TURKS AND CAICOS ISLANDS",
        "TUVALU",
        "UGANDA",
        "UKRAINE",
        "UNITED ARAB EMIRATES",
        "UNITED KINGDOM",
        "UNITED STATES",
        "UNITED STATES MINOR OUTLYING ISLANDS",
        "URUGUAY",
        "UZBEKISTAN",
        "VANUATU",
        "VENEZUELA",
        "VIET NAM",
        "VIRGIN ISLANDS, BRITISH",
        "VIRGIN ISLANDS, U.S.",
        "WALLIS AND FUTUNA",
        "WESTERN SAHARA",
        "YEMEN",
        "YUGOSLAVIA",
        "ZAMBIA",
        "ZIMBABWE",
    ]
    
    static public func getStates(code: String) -> String{
        let states: Dictionary<String, String> = [
            "AL":"ALABAMA",
            "AK":"ALASKA",
            "AS":"AMERICAN SAMOA",
            "AZ":"ARIZONA",
            "AR":"ARKANSAS",
            "CA":"CALIFORNIA",
            "CO":"COLORADO",
            "CT":"CONNECTICUT",
            "DE":"DELAWARE",
            "DC":"DISTRICT OF COLUMBIA",
            "FM":"FEDERATED STATES OF MICRONESIA",
            "FL":"FLORIDA",
            "GA":"GEORGIA",
            "GU":"GUAM GU",
            "HI":"HAWAII",
            "ID":"IDAHO",
            "IL":"ILLINOIS",
            "IN":"INDIANA",
            "IA":"IOWA",
            "KS":"KANSAS",
            "KY":"KENTUCKY",
            "LA":"LOUISIANA",
            "ME":"MAINE",
            "MH":"MARSHALL ISLANDS",
            "MD":"MARYLAND",
            "MA":"MASSACHUSETTS",
            "MI":"MICHIGAN",
            "MN":"MINNESOTA",
            "MS":"MISSISSIPPI",
            "MO":"MISSOURI",
            "MT":"MONTANA",
            "NE":"NEBRASKA",
            "NV":"NEVADA",
            "NH":"NEW HAMPSHIRE",
            "NJ":"NEW JERSEY",
            "NM":"NEW MEXICO",
            "NY":"NEW YORK",
            "NC":"NORTH CAROLINA",
            "ND":"NORTH DAKOTA",
            "MP":"NORTHERN MARIANA ISLANDS",
            "OH":"OHIO",
            "OK":"OKLAHOMA",
            "OR":"OREGON",
            "PW":"PALAU",
            "PA":"PENNSYLVANIA",
            "PR":"PUERTO RICO",
            "RI":"RHODE ISLAND",
            "SC":"SOUTH CAROLINA",
            "SD":"SOUTH DAKOTA",
            "TN":"TENNESSEE",
            "TX":"TEXAS",
            "UT":"UTAH",
            "VT":"VERMONT",
            "VI":"VIRGIN ISLANDS",
            "VA":"VIRGINIA",
            "WA":"WASHINGTON",
            "WV":"WEST VIRGINIA",
            "WI":"WISCONSIN",
            "WY":"WYOMING",
            "AE":"ARMED FORCES AFRICA | CANADA | EUROPE | MIDDLE EAST",
            "AA":"ARMED FORCES AMERICA (EXCEPT CANADA)",
            "AP":"ARMED FORCES PACIFIC"
            ]
        return states[code]!
    }
    
    static public func getCountries(code: String) -> String {
        let countries: Dictionary<String, String> = [
        "AF":"AFGHANISTAN",
        "AL":"ALBANIA",
        "DZ":"ALGERIA",
        "AS":"AMERICAN SAMOA",
        "AD":"ANDORRA",
        "AO":"ANGOLA",
        "AI":"ANGUILLA",
        "AQ":"ANTARCTICA",
        "AG":"ANTIGUA AND BARBUDA",
        "AR":"ARGENTINA",
        "AM":"ARMENIA",
        "AW":"ARUBA",
        "AU":"AUSTRALIA",
        "AT":"AUSTRIA",
        "AZ":"AZERBAIJAN",
        "BS":"BAHAMAS",
        "BH":"BAHRAIN",
        "BD":"BANGLADESH",
        "BB":"BARBADOS",
        "BY":"BELARUS",
        "BE":"BELGIUM",
        "BZ":"BELIZE",
        "BJ":"BENIN",
        "BM":"BERMUDA",
        "BT":"BHUTAN",
        "BO":"BOLIVIA",
        "BA":"BOSNIA AND HERZEGOVINA",
        "BW":"BOTSWANA",
        "BV":"BOUVET ISLAND",
        "BR":"BRAZIL",
        "IO":"BRITISH INDIAN OCEAN TERRITORY",
        "BN":"BRUNEI DARUSSALAM",
        "BG":"BULGARIA",
        "BF":"BURKINA FASO",
        "BI":"BURUNDI",
        "KH":"CAMBODIA",
        "CM":"CAMEROON",
        "CA":"CANADA",
        "CV":"CAPE VERDE",
        "KY":"CAYMAN ISLANDS",
        "CF":"CENTRAL AFRICAN REPUBLIC",
        "TD":"CHAD",
        "CL":"CHILE",
        "CN":"CHINA",
        "CX":"CHRISTMAS ISLAND",
        "CC":"COCOS (KEELING) ISLANDS",
        "CO":"COLOMBIA",
        "KM":"COMOROS",
        "CG":"CONGO",
        "CD":"CONGO, THE DEMOCRATIC REPUBLIC OF THE",
        "CK":"COOK ISLANDS",
        "CR":"COSTA RICA",
        "CI":"COTE D IVOIRE",
        "HR":"CROATIA",
        "CU":"CUBA",
        "CY":"CYPRUS",
        "CZ":"CZECH REPUBLIC",
        "DK":"DENMARK",
        "DJ":"DJIBOUTI",
        "DM":"DOMINICA",
        "DO":"DOMINICAN REPUBLIC",
        "TP":"EAST TIMOR",
        "EC":"ECUADOR",
        "EG":"EGYPT",
        "SV":"EL SALVADOR",
        "GQ":"EQUATORIAL GUINEA",
        "ER":"ERITREA",
        "EE":"ESTONIA",
        "ET":"ETHIOPIA",
        "FK":"FALKLAND ISLANDS (MALVINAS)",
        "FO":"FAROE ISLANDS",
        "FJ":"FIJI",
        "FI":"FINLAND",
        "FR":"FRANCE",
        "GF":"FRENCH GUIANA",
        "PF":"FRENCH POLYNESIA",
        "TF":"FRENCH SOUTHERN TERRITORIES",
        "GA":"GABON",
        "GM":"GAMBIA",
        "GE":"GEORGIA",
        "DE":"GERMANY",
        "GH":"GHANA",
        "GI":"GIBRALTAR",
        "GR":"GREECE",
        "GL":"GREENLAND",
        "GD":"GRENADA",
        "GP":"GUADELOUPE",
        "GU":"GUAM",
        "GT":"GUATEMALA",
        "GN":"GUINEA",
        "GW":"GUINEA-BISSAU",
        "GY":"GUYANA",
        "HT":"HAITI",
        "HM":"HEARD ISLAND AND MCDONALD ISLANDS",
        "VA":"HOLY SEE (VATICAN CITY STATE)",
        "HN":"HONDURAS",
        "HK":"HONG KONG",
        "HU":"HUNGARY",
        "IS":"ICELAND",
        "IN":"INDIA",
        "ID":"INDONESIA",
        "IR":"IRAN, ISLAMIC REPUBLIC OF",
        "IQ":"IRAQ",
        "IE":"IRELAND",
        "IL":"ISRAEL",
        "IT":"ITALY",
        "JM":"JAMAICA",
        "JP":"JAPAN",
        "JO":"JORDAN",
        "KZ":"KAZAKSTAN",
        "KE":"KENYA",
        "KI":"KIRIBATI",
        "KP":"KOREA DEMOCRATIC PEOPLES REPUBLIC OF",
        "KR":"KOREA REPUBLIC OF",
        "KW":"KUWAIT",
        "KG":"KYRGYZSTAN",
        "LA":"LAO PEOPLES DEMOCRATIC REPUBLIC",
        "LV":"LATVIA",
        "LB":"LEBANON",
        "LS":"LESOTHO",
        "LR":"LIBERIA",
        "LY":"LIBYAN ARAB JAMAHIRIYA",
        "LI":"LIECHTENSTEIN",
        "LT":"LITHUANIA",
        "LU":"LUXEMBOURG",
        "MO":"MACAU",
        "MK":"MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF",
        "MG":"MADAGASCAR",
        "MW":"MALAWI",
        "MY":"MALAYSIA",
        "MV":"MALDIVES",
        "ML":"MALI",
        "MT":"MALTA",
        "MH":"MARSHALL ISLANDS",
        "MQ":"MARTINIQUE",
        "MR":"MAURITANIA",
        "MU":"MAURITIUS",
        "YT":"MAYOTTE",
        "MX":"MEXICO",
        "FM":"MICRONESIA, FEDERATED STATES OF",
        "MD":"MOLDOVA, REPUBLIC OF",
        "MC":"MONACO",
        "MN":"MONGOLIA",
        "MS":"MONTSERRAT",
        "MA":"MOROCCO",
        "MZ":"MOZAMBIQUE",
        "MM":"MYANMAR",
        "NA":"NAMIBIA",
        "NR":"NAURU",
        "NP":"NEPAL",
        "NL":"NETHERLANDS",
        "AN":"NETHERLANDS ANTILLES",
        "NC":"NEW CALEDONIA",
        "NZ":"NEW ZEALAND",
        "NI":"NICARAGUA",
        "NE":"NIGER",
        "NG":"NIGERIA",
        "NU":"NIUE",
        "NF":"NORFOLK ISLAND",
        "MP":"NORTHERN MARIANA ISLANDS",
        "NO":"NORWAY",
        "OM":"OMAN",
        "PK":"PAKISTAN",
        "PW":"PALAU",
        "PS":"PALESTINIAN TERRITORY, OCCUPIED",
        "PA":"PANAMA",
        "PG":"PAPUA NEW GUINEA",
        "PY":"PARAGUAY",
        "PE":"PERU",
        "PH":"PHILIPPINES",
        "PN":"PITCAIRN",
        "PL":"POLAND",
        "PT":"PORTUGAL",
        "PR":"PUERTO RICO",
        "QA":"QATAR",
        "RE":"REUNION",
        "RO":"ROMANIA",
        "RU":"RUSSIAN FEDERATION",
        "RW":"RWANDA",
        "SH":"SAINT HELENA",
        "KN":"SAINT KITTS AND NEVIS",
        "LC":"SAINT LUCIA",
        "PM":"SAINT PIERRE AND MIQUELON",
        "VC":"SAINT VINCENT AND THE GRENADINES",
        "WS":"SAMOA",
        "SM":"SAN MARINO",
        "ST":"SAO TOME AND PRINCIPE",
        "SA":"SAUDI ARABIA",
        "SN":"SENEGAL",
        "SC":"SEYCHELLES",
        "SL":"SIERRA LEONE",
        "SG":"SINGAPORE",
        "SK":"SLOVAKIA",
        "SI":"SLOVENIA",
        "SB":"SOLOMON ISLANDS",
        "SO":"SOMALIA",
        "ZA":"SOUTH AFRICA",
        "GS":"SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS",
        "ES":"SPAIN",
        "LK":"SRI LANKA",
        "SD":"SUDAN",
        "SR":"SURINAME",
        "SJ":"SVALBARD AND JAN MAYEN",
        "SZ":"SWAZILAND",
        "SE":"SWEDEN",
        "CH":"SWITZERLAND",
        "SY":"SYRIAN ARAB REPUBLIC",
        "TW":"TAIWAN, PROVINCE OF CHINA",
        "TJ":"TAJIKISTAN",
        "TZ":"TANZANIA, UNITED REPUBLIC OF",
        "TH":"THAILAND",
        "TG":"TOGO",
        "TK":"TOKELAU",
        "TO":"TONGA",
        "TT":"TRINIDAD AND TOBAGO",
        "TN":"TUNISIA",
        "TR":"TURKEY",
        "TM":"TURKMENISTAN",
        "TC":"TURKS AND CAICOS ISLANDS",
        "TV":"TUVALU",
        "UG":"UGANDA",
        "UA":"UKRAINE",
        "AE":"UNITED ARAB EMIRATES",
        "GB":"UNITED KINGDOM",
        "US":"UNITED STATES",
        "UM":"UNITED STATES MINOR OUTLYING ISLANDS",
        "UY":"URUGUAY",
        "UZ":"UZBEKISTAN",
        "VU":"VANUATU",
        "VE":"VENEZUELA",
        "VN":"VIET NAM",
        "VG":"VIRGIN ISLANDS, BRITISH",
        "VI":"VIRGIN ISLANDS, U.S.",
        "WF":"WALLIS AND FUTUNA",
        "EH":"WESTERN SAHARA",
        "YE":"YEMEN",
        "YU":"YUGOSLAVIA",
        "ZM":"ZAMBIA",
        "ZW":"ZIMBABWE",
        ]
    
        return countries[code]!
    }

}
