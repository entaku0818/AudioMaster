//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 2022/05/05.
//

import Foundation


extension DateFormatter {

    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "ja_JP")
    }

    /* 日付フォーマット(yyyy/MM/dd) */
    static let DF_YMD_slash = DateFormatter(format: "yyyy/MM/dd")

    /* 日付フォーマット(yyyy-MM-dd) */
    static let DF_YMD_dash = DateFormatter(format: "yyyy-MM-dd")

    /* 日付フォーマット(yyyyMM) */
    static let DF_YM = DateFormatter(format: "yyyyMM")

    /* 日付フォーマット(yyyy-MM) */
    static let DF_YM_dash = DateFormatter(format: "yyyy-MM")

    /* 日付フォーマット(YYYY/MM/DD HH:MM) */
    static let DF_YMDHM = DateFormatter(format: "yyyy/MM/dd HH:mm")

    /* 日付フォーマット(YYYY/MM/DD HH:MM:SS) */
    static let DF_YMDHMS = DateFormatter(format: "yyyy/MM/dd HH:mm:ss")

    /* 日付フォーマット(YYYY/MM/DD HH:MM:SS) */
    static let yyyyMMddHHmmss = DateFormatter(format: "yyyyMMddHHmmss")

    /* 日付フォーマット(MM/DD/YYYY) */
    static let DF_MDY = DateFormatter(format: "MM/dd/yyyy")

    /* 日付フォーマット(Y年M月)(0埋め無し) */
    static let DF_YM_S = DateFormatter(format: "y年M月")

    /* 日付フォーマット(Y年M月D日)(0埋め無し) */
    static let DF_YMD_S = DateFormatter(format: "y年M月d日")

    /* 日付フォーマット(Y年M月D日 H:MM)(0埋め無し) */
    static let DF_YMDHM_S = DateFormatter(format: "y年M月d日 H:mm")

    /* 日付フォーマット(M月D日)(0埋め無し) */
    static let DF_MD_S = DateFormatter(format: "M月d日")

    /* 日付フォーマット(M月D日 H:MM)(0埋め無し) */
    static let DF_MDHM_S = DateFormatter(format: "M月d日 H:mm")

    /* 日付フォーマット(H:MM)(0埋め無し) */
    static let DF_HM_S = DateFormatter(format: "H:mm")
}
