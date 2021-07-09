#' ESAC Contracts
#'
#' Hand-coded transparency ratings on transformational agreements.
#'
#' @format
#' A data frame with the following variables:
#'
#' | **Variable** | **Description** |
#' | ------------ | --------------- |
#' | `publisher` |  |
#' | `country` | (in german) |
#' | `buyer` | Buying-side institution (abbreviation) |
#' | `volume` | Number of annual publications by corresponding authors covered by the buy-side institution. |
#' | `start` | Start of contract |
#' | `end` | End of contract |
#' | `cost_increase` | Did agreement costs increase compared to the previous subscription-only contract?|
#' | `cost_increase_comment` | Comment on cost development |
#' | `risk_sharing` | How do entitlements for open access publishing correlate to the anticipated article output? Which mechanisms for risk sharing have been agreed in cases of exceeding or not reaching the number of oa publishing entitlements? |
#' | `financial_shift` | Transfomative agreements vary by their transformative mechanisms, meaning the way in which financing is shifted from the subscription side to open access publishing. What are the characteristics of this agreement to this regard? |
#' | `cap_ceiling` | |
#' | `oa_coverage` | Are all journals relevant to your affiliated authors (in which you expect them to publish) eligible for oa publishing under the agreement? |
#' | `oa_fully` | Are fully open access journals covered by the agreement? |
#' | `oa_license` | How mandatory is `cc-by` licensing? |
#' | `access_costs` | What is the approximate share of access related costs of the overall agreement? |
#' | `access_costs_comment | What is the approximate share of access related costs of the overall agreement? (comments) |
#' | `coverage_read` | Are all read relevant journals covered by the agreement? |
#' | `no_deadline` | Is access unlimited? |
#' | `assessments_wf` | Workflow assessment (open text field) |
#' | `assessment_overall` | Overall Assessment and comments (open text field) |
#' | `contract_url` | URL to contract |
#' | `last_viewed` | Last viewed |
#' | `includes` | Agreement inclusions, open text |
#' | `includes_ora` | Agreement includes original research article (ORA) |
#' | `includes_ebook` | Agreement includes ebooks |
#' | `includes_ra` | Agreement includes review articles (RA) |
#' | `includes_proc` | Agreement includes proceedings |
#' | `includes_ed` | Agreement includes editorials |
#' | `includes_letters` | Agreement includes letters |
#' | `includes_edu` | Agreement includes continuing education |
#' | `includes_brief` | Agreement includes brief communication |
#' | `includes_case_report` | Agreement includes case reports |
#' | `includes_tut` | Agreement includes tutorials |
#' | `includes_rapid` | Agreement includes rapid publication |
#' | `includes_add` | Agreement includes additions |
#' | `includes_corr` | Agreement includes corrections |
#' | `includes_comm` | Agreement includes communications |
#' | `includes_book_rev` | Agreement includes book reviews |
#' | `includes_reports` | Agreement includes reports |
#' | `includes_software` | Agreement includes software publication |
#' | `includes_video_article` | Agreement includes video articles |
#' | `includes_prtcl` | Agreement includes protocols |
#' | `includes_data_brief` | Agreement includes data in brief |
#' | `includes_insights` | Agreement includes insights |
#' | `include_commentaries` | Agreement includes commentaries |
#'
#'
esac_contracts <- NULL
