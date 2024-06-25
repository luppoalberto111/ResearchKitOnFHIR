//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable duplicate_imports function_default_parameter_at_end
import ModelsR4
import ResearchKit
@_exported import class ResearchKit.ORKNavigableOrderedTask


extension ORKNavigableOrderedTask {
    /// Create a `ORKNavigableOrderedTask` by parsing a FHIR `Questionnaire`. Throws a `FHIRToResearchKitConversionError` if an error happens during the parsing.
    /// - Parameters:
    ///  - title: The title of the questionnaire. If you pass in a `String` the translation overrides the title that might be provided in the FHIR `Questionnaire`.
    ///  - questionnaire: The FHIR `Questionnaire` used to create the `ORKNavigableOrderedTask`.
    ///  - completionStep: An optional `ORKCompletionStep` that can be displayed at the end of the ResearchKit survey.
    public convenience init(
        title: String? = nil,
        questionnaire: Questionnaire,
        completionStep: ORKCompletionStep? = nil
    ) throws {
        guard let item = questionnaire.item else {
            throw FHIRToResearchKitConversionError.noItems
        }
        
        // The task ID is set to the canonical URL of the questionnaire. If not present, random UUID string will be used
        let id = questionnaire.url?.value?.url.absoluteString ?? UUID().uuidString
        
        // Convert each FHIR Questionnaire Item to an ORKStep
        let valueSets = questionnaire.getContainedValueSets()
        let title = (title ?? questionnaire.title?.value?.string) ?? ""
        var steps = item.fhirQuestionnaireItemsToORKSteps(title: title, valueSets: valueSets)
        
        // Add a completion step at the end of the task if defined
        if let completionStep = completionStep {
            steps.append(completionStep)
        }
        
        self.init(identifier: id, steps: steps)
        
        // If any questions have defined skip logic, convert to ResearchKit navigation rules
        try constructNavigationRules(questions: item)
    }
}
