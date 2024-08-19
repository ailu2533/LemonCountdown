//
//  icons.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/20.
//

import Collections
import Foundation

let desserts: [String] = [
    "001-christmas cookie",
    "002-pumpkin",
    "003-cinnamon roll",
    "004-shaved ice",
    "005-cheesecake",
    "006-jelly beans",
    "007-cupcake",
    "008-cake pop",
    "009-sundae",
    "010-popsicle",
    "011-dango",
    "012-pumpkin pie",
    "013-ice cream",
    "014-pudding",
    "015-chocolate bar",
    "016-donuts",
    "017-candies",
    "018-lollipop",
    "019-milkshake",
    "020-ice cream"
]

let animals: [String] = [
        "dog_1864532",
        "elephant_1864469",
        "hen_1864470",
        "monkey_1864483",
        "parrot_1864474",
        "sheep_1864535",
        "beach_2990644",
        "dolphin_1864473",
        "hedgehog_1864601",
        "koala_1864527",
        "panda-bear_1864516",
        "rabbit_1864488",
        "squirrel_1864480"
]

let emoji = [
     "idea_8231426",
        "laughing_8231446",
        "love_2018269",
        "smileys_9470713",
        "stars_8231347",
        "tired_2018421"
]

let iconsMap: OrderedDictionary<String, [String]> = [
    String(localized: "表情"): emoji,
    String(localized: "甜点"): desserts,
    String(localized: "动物"): animals
]

