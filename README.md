"""
Category Growth Simulator - Core Calculation Engine
Stage B: Implementation
"""

import pandas as pd
import numpy as np
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, field
import json


@dataclass
class SimulatorConfig:
    """Base configuration for the simulator"""
    category_size: float = 1000000  # Total category volume
    penetration: float = 0.25  # Household penetration
    frequency: float = 3.5  # Purchases per buyer
    distribution: float = 0.70  # % outlets stocked
    average_price: float = 150  # Weighted average price
    premium_mix: float = 0.15  # % premium SKUs
    market_share: float = 0.18  # Brand share of category
    households: float = 35000000  # Target household base
    retailers: float = 50000  # Total outlet universe
    margin_rate: float = 0.45  # Gross margin %
    variable_costs: float = 0.30  # Variable costs as % of revenue
    investment: float = 0  # Investment required


@dataclass
class ScenarioResult:
    """Results from a single scenario run"""
    name: str
    volume: float
    revenue: float
    gross_margin: float
    contribution: float
    net_profit: float
    roi: float
    penetration: float
    frequency: float
    distribution: float
    avg_price: float
    premium_mix: float
    market_share: float
    investment: float


class CategoryGrowthSimulator:
    """
    Core simulation engine for category growth modeling
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize simulator with base configuration
        
        Args:
            config: Dictionary containing base parameters
        """
        self.config = SimulatorConfig(**config)
        self.scenarios = []
        self.results = []
    
    def calculate_brand_volume(self, penetration: float, frequency: float) -> float:
        """Calculate total brand volume"""
        buyers = self.config.households * penetration
        return buyers * frequency
    
    def calculate_category_volume(self) -> float:
        """Calculate total category volume"""
        return self.config.category_size
    
    def calculate_revenue(self, volume: float, avg_price: float) -> float:
        """Calculate total revenue"""
        return volume * avg_price
    
    def calculate_gross_margin(self, revenue: float) -> float:
        """Calculate gross margin"""
        return revenue * self.config.margin_rate
    
    def calculate_contribution(self, revenue: float) -> float:
        """Calculate contribution after variable costs"""
        variable_cost = revenue * self.config.variable_costs
        return revenue - variable_cost
    
    def calculate_roi(self, contribution: float, investment: float) -> float:
        """Calculate return on investment"""
        if investment == 0:
            return float('inf')
        return (contribution - investment) / investment
    
    def calculate_market_share(self, brand_volume: float, category_volume: float) -> float:
        """Calculate market share"""
        if category_volume == 0:
            return 0
        return brand_volume / category_volume
    
    def run_scenario(self, scenario: Dict[str, Any]) -> ScenarioResult:
        """
        Run a single scenario with specified multipliers
        
        Args:
            scenario: Dictionary with scenario parameters
        
        Returns:
            ScenarioResult object with all outputs
        """
        # Apply multipliers to base variables
        penetration = self.config.penetration * scenario.get('penetration_multiplier', 1.0)
        frequency = self.config.frequency * scenario.get('frequency_multiplier', 1.0)
        distribution = self.config.distribution * scenario.get('distribution_multiplier', 1.0)
        avg_price = self.config.average_price * scenario.get('pricing_multiplier', 1.0)
        premium_mix = self.config.premium_mix * scenario.get('premium_mix_multiplier', 1.0)
        investment = scenario.get('investment', 0)
        
        # Cap variables at reasonable limits
        penetration = min(penetration, 0.95)
        distribution = min(distribution, 0.98)
        premium_mix = min(premium_mix, 0.80)
        
        # Calculate volume
        brand_volume = self.calculate_brand_volume(penetration, frequency)
        category_volume = self.calculate_category_volume()
        
        # Calculate revenue
        revenue = self.calculate_revenue(brand_volume, avg_price)
        
        # Calculate margins
        gross_margin = self.calculate_gross_margin(revenue)
        contribution = self.calculate_contribution(revenue)
        
        # Calculate ROI
        roi = self.calculate_roi(contribution, investment)
        
        # Calculate market share
        market_share = self.calculate_market_share(brand_volume, category_volume)
        
        # Calculate net profit
        net_profit = contribution - investment
        
        return ScenarioResult(
            name=scenario.get('name', 'Unnamed Scenario'),
            volume=brand_volume,
            revenue=revenue,
            gross_margin=gross_margin,
            contribution=contribution,
            net_profit=net_profit,
            roi=roi,
            penetration=penetration,
            frequency=frequency,
            distribution=distribution,
            avg_price=avg_price,
            premium_mix=premium_mix,
            market_share=market_share,
            investment=investment
        )
    
    def run_scenarios(self, scenarios: List[Dict[str, Any]]) -> List[ScenarioResult]:
        """
        Run multiple scenarios
        
        Args:
            scenarios: List of scenario dictionaries
        
        Returns:
            List of ScenarioResult objects
        """
        self.results = []
        for scenario in scenarios:
            result = self.run_scenario(scenario)
            self.results.append(result)
        return self.results
    
    def compare_scenarios(self, results: List[ScenarioResult]) -> pd.DataFrame:
        """
        Compare multiple scenarios and return DataFrame
        
        Args:
            results: List of ScenarioResult objects
        
        Returns:
            DataFrame with comparison metrics
        """
        data = []
        for r in results:
            data.append({
                'Scenario': r.name,
                'Volume': r.volume,
                'Revenue': r.revenue,
                'Gross Margin': r.gross_margin,
                'Contribution': r.contribution,
                'Net Profit': r.net_profit,
                'ROI': r.roi,
                'Penetration': r.penetration,
                'Frequency': r.frequency,
                'Distribution': r.distribution,
                'Avg Price': r.avg_price,
                'Premium Mix': r.premium_mix,
                'Market Share': r.market_share,
                'Investment': r.investment
            })
        
        return pd.DataFrame(data)
    
    def calculate_impact(self, base_result: ScenarioResult, 
                        scenario_result: ScenarioResult) -> Dict[str, float]:
        """
        Calculate the impact of a scenario compared to base
        
        Args:
            base_result: Base scenario result
            scenario_result: Scenario to compare
        
        Returns:
            Dictionary with percentage and absolute changes
        """
        return {
            'volume_change_abs': scenario_result.volume - base_result.volume,
            'volume_change_pct': ((scenario_result.volume / base_result.volume) - 1) * 100,
            'revenue_change_abs': scenario_result.revenue - base_result.revenue,
            'revenue_change_pct': ((scenario_result.revenue / base_result.revenue) - 1) * 100,
            'margin_change_abs': scenario_result.gross_margin - base_result.gross_margin,
            'margin_change_pct': ((scenario_result.gross_margin / base_result.gross_margin) - 1) * 100,
            'roi_improvement': scenario_result.roi - base_result.roi,
            'market_share_change': (scenario_result.market_share - base_result.market_share) * 100
        }
    
    def find_optimal_investment(self, scenario_template: Dict[str, Any], 
                               investment_range: List[float]) -> Dict[str, Any]:
        """
        Find optimal investment level for a scenario
        
        Args:
            scenario_template: Base scenario configuration
            investment_range: List of investment amounts to test
        
        Returns:
            Dictionary with optimal investment and results
        """
        results = []
        for investment in investment_range:
            scenario = scenario_template.copy()
            scenario['investment'] = investment
            result = self.run_scenario(scenario)
            results.append({
                'investment': investment,
                'roi': result.roi,
                'net_profit': result.net_profit,
                'revenue': result.revenue
            })
        
        # Find investment with highest ROI
        optimal = max(results, key=lambda x: x['roi'])
        
        return {
            'optimal_investment': optimal['investment'],
            'max_roi': optimal['roi'],
            'all_results': results
        }
    
    def export_results(self, results: List[ScenarioResult], 
                      filename: str = 'scenario_results.xlsx'):
        """
        Export results to Excel
        
        Args:
            results: List of ScenarioResult objects
            filename: Output filename
        """
        df = self.compare_scenarios(results)
        
        with pd.ExcelWriter(filename, engine='openpyxl') as writer:
            df.to_excel(writer, sheet_name='Scenario Comparison', index=False)
            
            # Add summary statistics
            summary = df[['Scenario', 'Volume', 'Revenue', 'Net Profit', 'ROI']].copy()
            summary.to_excel(writer, sheet_name='Summary', index=False)
    
    def get_summary_stats(self, results: List[ScenarioResult]) -> Dict[str, Any]:
        """
        Get summary statistics across all scenarios
        
        Args:
            results: List of ScenarioResult objects
        
        Returns:
            Dictionary with summary statistics
        """
        volumes = [r.volume for r in results]
        revenues = [r.revenue for r in results]
        rois = [r.roi for r in results]
        market_shares = [r.market_share for r in results]
        
        return {
            'total_scenarios': len(results),
            'avg_volume': np.mean(volumes),
            'avg_revenue': np.mean(revenues),
            'avg_roi': np.mean(rois),
            'max_volume': max(volumes),
            'max_revenue': max(revenues),
            'max_roi': max(rois),
            'best_scenario': results[np.argmax(rois)].name,
            'volume_range': (min(volumes), max(volumes)),
            'roi_range': (min(rois), max(rois))
        }


# Pre-built scenario templates
SCENARIO_TEMPLATES = {
    'penetration_focus': {
        'name': 'Penetration Focus',
        'penetration_multiplier': 1.15,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 30000000
    },
    'distribution_focus': {
        'name': 'Distribution Focus',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.20,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 20000000
    },
    'frequency_focus': {
        'name': 'Frequency Focus',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.10,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 15000000
    },
    'premiumization': {
        'name': 'Premiumization',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.18,
        'premium_mix_multiplier': 1.50,
        'investment': 15000000
    },
    'combined_growth': {
        'name': 'Combined Growth Strategy',
        'penetration_multiplier': 1.12,
        'frequency_multiplier': 1.05,
        'distribution_multiplier': 1.15,
        'pricing_multiplier': 1.08,
        'premium_mix_multiplier': 1.30,
        'investment': 50000000
    },
    'aggressive_expansion': {
        'name': 'Aggressive Expansion',
        'penetration_multiplier': 1.20,
        'frequency_multiplier': 1.10,
        'distribution_multiplier': 1.25,
        'pricing_multiplier': 0.95,
        'premium_mix_multiplier': 1.20,
        'investment': 75000000
    }
}