"""
Category Growth Simulator - Nectar Syrup Case Analysis
Complete working example using the simulator
"""

import sys
sys.path.append('..')

from src.simulator import CategoryGrowthSimulator, SCENARIO_TEMPLATES
from src.visualizations import GrowthVisualizer
import pandas as pd

# Base configuration for Nectar Syrup
base_config = {
    'category_size': 15000000,  # Total syrup category in units
    'penetration': 0.12,  # Nectar's household penetration
    'frequency': 4.2,  # Purchases per year
    'distribution': 0.65,  # Distribution coverage
    'average_price': 150,  # Weighted average price
    'premium_mix': 0.18,  # Premium SKU share
    'market_share': 0.18,  # Nectar's share of category
    'households': 35000000,  # Total Indian households
    'retailers': 50000,  # Total outlets
    'margin_rate': 0.45,  # Gross margin
    'variable_costs': 0.30,  # Variable costs
    'investment': 0  # Base case investment
}

# Initialize simulator
sim = CategoryGrowthSimulator(base_config)

# Run multiple scenarios
scenarios = [
    {'name': 'Base Case', **{k: 1.0 for k in ['penetration_multiplier', 'frequency_multiplier', 
                                               'distribution_multiplier', 'pricing_multiplier', 
                                               'premium_mix_multiplier']}, 'investment': 0},
    SCENARIO_TEMPLATES['distribution_focus'],
    SCENARIO_TEMPLATES['premiumization'],
    SCENARIO_TEMPLATES['combined_growth'],
    SCENARIO_TEMPLATES['aggressive_expansion']
]

# Run all scenarios
results = sim.run_scenarios(scenarios)

# Get comparison DataFrame
comparison_df = sim.compare_scenarios(results)
print("\n" + "="*80)
print("SCENARIO COMPARISON")
print("="*80)
print(comparison_df.to_string(index=False))

# Calculate impacts
base_result = results[0]
print("\n" + "="*80)
print("IMPACT ANALYSIS")
print("="*80)
for result in results[1:]:
    impact = sim.calculate_impact(base_result, result)
    print(f"\n{result.name}:")
    print(f"  Volume Change: {impact['volume_change_pct']:+.1f}% ({impact['volume_change_abs']:,.0f} units)")
    print(f"  Revenue Change: {impact['revenue_change_pct']:+.1f}% (₹{impact['revenue_change_abs']:,.0f})")
    print(f"  Margin Change: {impact['margin_change_pct']:+.1f}% (₹{impact['margin_change_abs']:,.0f})")
    print(f"  ROI: {result.roi:.2f}x")
    print(f"  Market Share Change: {impact['market_share_change']:+.1f}pp")

# Export to Excel
sim.export_results(results, 'nectar_syrup_scenarios.xlsx')
print(f"\n📊 Results exported to 'nectar_syrup_scenarios.xlsx'")

# Create visualizations
viz = GrowthVisualizer()

# ROI comparison chart
fig1 = viz.plot_roi_comparison(comparison_df)
fig1.savefig('roi_comparison.png', dpi=300, bbox_inches='tight')
print("📈 ROI comparison saved to 'roi_comparison.png'")

# Scenario comparison chart
fig2 = viz.plot_scenario_comparison(comparison_df, 
                                   metrics=['Volume', 'Revenue', 'Net Profit'])
fig2.savefig('scenario_comparison.png', dpi=300, bbox_inches='tight')
print("📈 Scenario comparison saved to 'scenario_comparison.png'")

# Find optimal investment for distribution scenario
investment_range = list(range(5000000, 60000001, 5000000))
optimal_results = sim.find_optimal_investment(
    SCENARIO_TEMPLATES['distribution_focus'],
    investment_range
)

print("\n" + "="*80)
print("OPTIMAL INVESTMENT ANALYSIS")
print("="*80)
print(f"Optimal Investment: ₹{optimal_results['optimal_investment']:,.0f}")
print(f"Maximum ROI: {optimal_results['max_roi']:.2f}x")

# Summary statistics
summary = sim.get_summary_stats(results)
print("\n" + "="*80)
print("SUMMARY STATISTICS")
print("="*80)
for key, value in summary.items():
    if isinstance(value, (int, float)):
        if 'volume' in key or 'revenue' in key or 'roi' in key:
            print(f"  {key.replace('_', ' ').title()}: {value:,.0f}")
        else:
            print(f"  {key.replace('_', ' ').title()}: {value}")
    else:
        print(f"  {key.replace('_', ' ').title()}: {value}")

# Print recommendations
print("\n" + "="*80)
print("STRATEGIC RECOMMENDATIONS")
print("="*80)

best_scenario = results[np.argmax([r.roi for r in results])]
print(f"\n🏆 Best ROI Scenario: {best_scenario.name} ({best_scenario.roi:.2f}x ROI)")

highest_revenue = results[np.argmax([r.revenue for r in results])]
print(f"💰 Highest Revenue Scenario: {highest_revenue.name} (₹{highest_revenue.revenue:,.0f})")

# Scenario-specific recommendations
for result in results[1:]:  # Skip base case
    impact = sim.calculate_impact(base_result, result)
    print(f"\n{result.name}:")
    if impact['roi_improvement'] > 0.5:
        print(f"  ✅ Strong ROI improvement: +{impact['roi_improvement']:.2f}x")
    if impact['revenue_change_pct'] > 15:
        print(f"  ✅ Significant revenue growth: +{impact['revenue_change_pct']:.1f}%")
    if impact['market_share_change'] > 2:
        print(f"  ✅ Market share gain: +{impact['market_share_change']:.1f}pp")