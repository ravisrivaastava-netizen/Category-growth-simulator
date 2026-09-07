# Run complete Nectar Syrup analysis
python examples/nectar_syrup_analysis.py

# Run basic example
python examples/basic_usage.py

# Run tests
pytest tests/

# Generate all visualizations
python -c "from src.visualizations import GrowthVisualizer; viz = GrowthVisualizer()"