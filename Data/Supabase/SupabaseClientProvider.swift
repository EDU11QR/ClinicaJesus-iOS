//
//  SupabaseClientProvider.swift
//  ClinicaJesusIOS
//
//  Created by XCODE on 19/04/26.
//
import Foundation
import Supabase

final class SupabaseClientProvider {
    static let shared = SupabaseClient(
        supabaseURL: AppConfig.supabaseURL,
        supabaseKey: AppConfig.supabaseKey
    )
}
